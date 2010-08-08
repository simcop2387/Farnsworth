<?php
/**
** A base module for [file] and [file*]
**/

/* Shortcode handler */

wpef7_add_shortcode( 'file', 'wpef7_file_shortcode_handler', true );
wpef7_add_shortcode( 'file*', 'wpef7_file_shortcode_handler', true );

function wpef7_file_shortcode_handler( $tag ) {
	global $wpef7_contact_form;

	if ( ! is_array( $tag ) )
		return '';

	$type = $tag['type'];
	$name = $tag['name'];
	$options = (array) $tag['options'];
	$values = (array) $tag['values'];

	if ( empty( $name ) )
		return '';

	$atts = '';
	$id_att = '';
	$class_att = '';
	$tabindex_att = '';

	$class_att .= ' wpef7-file';

	if ( 'file*' == $type )
		$class_att .= ' wpef7-validates-as-required';

	foreach ( $options as $option ) {
		if ( preg_match( '%^id:([-0-9a-zA-Z_]+)$%', $option, $matches ) ) {
			$id_att = $matches[1];

		} elseif ( preg_match( '%^class:([-0-9a-zA-Z_]+)$%', $option, $matches ) ) {
			$class_att .= ' ' . $matches[1];

		} elseif ( preg_match( '%^tabindex:(\d+)$%', $option, $matches ) ) {
			$tabindex_att = (int) $matches[1];

		}
	}

	if ( $id_att )
		$atts .= ' id="' . trim( $id_att ) . '"';

	if ( $class_att )
		$atts .= ' class="' . trim( $class_att ) . '"';

	if ( '' !== $tabindex_att )
		$atts .= sprintf( ' tabindex="%d"', $tabindex_att );

	$html = '<input type="file" name="' . $name . '"' . $atts . ' value="1" />';

	$validation_error = '';
	if ( is_a( $wpef7_contact_form, 'WPEF7_ContactForm' ) )
		$validation_error = $wpef7_contact_form->validation_error( $name );

	$html = '<span class="wpef7-form-control-wrap ' . $name . '">' . $html . $validation_error . '</span>';

	return $html;
}


/* Encode type filter */

add_filter( 'wpef7_form_enctype', 'wpef7_file_form_enctype_filter' );

function wpef7_file_form_enctype_filter( $enctype ) {
	global $wpef7_contact_form;

	$multipart = (bool) $wpef7_contact_form->form_scan_shortcode(
		array( 'type' => array( 'file', 'file*' ) ) );

	if ( $multipart )
		$enctype = ' enctype="multipart/form-data"';

	return $enctype;
}


/* Validation + upload handling filter */

add_filter( 'wpef7_validate_file', 'wpef7_file_validation_filter', 10, 2 );
add_filter( 'wpef7_validate_file*', 'wpef7_file_validation_filter', 10, 2 );

function wpef7_file_validation_filter( $result, $tag ) {
	global $wpef7_contact_form;

	$type = $tag['type'];
	$name = $tag['name'];
	$options = (array) $tag['options'];

	$file = $_FILES[$name];

	if ( $file['error'] && UPLOAD_ERR_NO_FILE != $file['error'] ) {
		$result['valid'] = false;
		$result['reason'][$name] = $wpef7_contact_form->message( 'upload_failed_php_error' );
		return $result;
	}

	if ( empty( $file['tmp_name'] ) && 'file*' == $type ) {
		$result['valid'] = false;
		$result['reason'][$name] = $wpef7_contact_form->message( 'invalid_required' );
		return $result;
	}

	if ( ! is_uploaded_file( $file['tmp_name'] ) )
		return $result;

	$file_type_pattern = '';
	$allowed_size = 1048576; // default size 1 MB

	foreach ( $options as $option ) {
		if ( preg_match( '%^filetypes:(.+)$%', $option, $matches ) ) {
			$file_types = explode( '|', $matches[1] );
			foreach ( $file_types as $file_type ) {
				$file_type = trim( $file_type, '.' );
				$file_type = str_replace(
					array( '.', '+', '*', '?' ), array( '\.', '\+', '\*', '\?' ), $file_type );
				$file_type_pattern .= '|' . $file_type;
			}

		} elseif ( preg_match( '/^limit:([1-9][0-9]*)([kKmM]?[bB])?$/', $option, $matches ) ) {
			$allowed_size = (int) $matches[1];

			$kbmb = strtolower( $matches[2] );
			if ( 'kb' == $kbmb ) {
				$allowed_size *= 1024;
			} elseif ( 'mb' == $kbmb ) {
				$allowed_size *= 1024 * 1024;
			}

		}
	}

	/* File type validation */

	// Default file-type restriction
	if ( '' == $file_type_pattern )
		$file_type_pattern = 'jpg|jpeg|png|gif|pdf|doc|docx|ppt|pptx|odt|avi|ogg|m4a|mov|mp3|mp4|mpg|wav|wmv';

	$file_type_pattern = trim( $file_type_pattern, '|' );
	$file_type_pattern = '(' . $file_type_pattern . ')';
	$file_type_pattern = '/\.' . $file_type_pattern . '$/i';

	if ( ! preg_match( $file_type_pattern, $file['name'] ) ) {
		$result['valid'] = false;
		$result['reason'][$name] = $wpef7_contact_form->message( 'upload_file_type_invalid' );
		return $result;
	}

	/* File size validation */

	if ( $file['size'] > $allowed_size ) {
		$result['valid'] = false;
		$result['reason'][$name] = $wpef7_contact_form->message( 'upload_file_too_large' );
		return $result;
	}

	$uploads_dir = wpef7_upload_tmp_dir();
	wpef7_init_uploads(); // Confirm upload dir

	$filename = $file['name'];

	// If you get script file, it's a danger. Make it TXT file.
	if ( preg_match( '/\.(php|pl|py|rb|cgi)\d?$/', $filename ) )
		$filename .= '.txt';

	// foo.php.jpg => foo.php_.jpg
	$filename = wpef7_sanitize_file_name( $filename );

	$filename = wp_unique_filename( $uploads_dir, $filename );

	$new_file = trailingslashit( $uploads_dir ) . $filename;

	if ( false === @move_uploaded_file( $file['tmp_name'], $new_file ) ) {
		$result['valid'] = false;
		$result['reason'][$name] = $wpef7_contact_form->message( 'upload_failed' );
		return $result;
	}

	// Make sure the uploaded file is only readable for the owner process
	@chmod( $new_file, 0400 );

	$wpef7_contact_form->uploaded_files[$name] = $new_file;

	if ( ! isset( $_POST[$name] ) )
		$_POST[$name] = $filename;

	return $result;
}


/* Messages */

add_filter( 'wpef7_messages', 'wpef7_file_messages' );

function wpef7_file_messages( $messages ) {
	return array_merge( $messages, array(
		'upload_failed' => array(
			'description' => __( "Uploading a file fails for any reason", 'wpef7' ),
			'default' => __( 'Failed to upload file.', 'wpef7' )
		),

		'upload_file_type_invalid' => array(
			'description' => __( "Uploaded file is not allowed file type", 'wpef7' ),
			'default' => __( 'This file type is not allowed.', 'wpef7' )
		),

		'upload_file_too_large' => array(
			'description' => __( "Uploaded file is too large", 'wpef7' ),
			'default' => __( 'This file is too large.', 'wpef7' )
		),

		'upload_failed_php_error' => array(
			'description' => __( "Uploading a file fails for PHP error", 'wpef7' ),
			'default' => __( 'Failed to upload file. Error occurred.', 'wpef7' )
		)
	) );
}


/* Tag generator */

add_action( 'admin_init', 'wpef7_add_tag_generator_file', 50 );

function wpef7_add_tag_generator_file() {
	wpef7_add_tag_generator( 'file', __( 'File upload', 'wpef7' ),
		'wpef7-tg-pane-file', 'wpef7_tg_pane_file' );
}

function wpef7_tg_pane_file( &$contact_form ) {
?>
<div id="wpef7-tg-pane-file" class="hidden">
<form action="">
<table>
<tr><td><input type="checkbox" name="required" />&nbsp;<?php echo esc_html( __( 'Required field?', 'wpef7' ) ); ?></td></tr>
<tr><td><?php echo esc_html( __( 'Name', 'wpef7' ) ); ?><br /><input type="text" name="name" class="tg-name oneline" /></td><td></td></tr>
</table>

<table>
<tr>
<td><code>id</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="id" class="idvalue oneline option" /></td>

<td><code>class</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="class" class="classvalue oneline option" /></td>
</tr>

<tr>
<td><?php echo esc_html( __( "File size limit", 'wpef7' ) ); ?> (<?php echo esc_html( __( 'bytes', 'wpef7' ) ); ?>) (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="limit" class="filesize oneline option" /></td>

<td><?php echo esc_html( __( "Acceptable file types", 'wpef7' ) ); ?> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="filetypes" class="filetype oneline option" /></td>
</tr>
</table>

<div class="tg-tag"><?php echo esc_html( __( "Copy this code and paste it into the form left.", 'wpef7' ) ); ?><br /><input type="text" name="file" class="tag" readonly="readonly" onfocus="this.select()" /></div>

<div class="tg-mail-tag"><?php echo esc_html( __( "And, put this code into the File Attachments field below.", 'wpef7' ) ); ?><br /><span class="arrow">&#11015;</span>&nbsp;<input type="text" class="mail-tag" readonly="readonly" onfocus="this.select()" /></div>
</form>
</div>
<?php
}


/* Warning message */

add_action( 'wpef7_admin_before_subsubsub', 'wpef7_file_display_warning_message' );

function wpef7_file_display_warning_message( &$contact_form ) {
	if ( ! $contact_form )
		return;

	$has_tags = (bool) $contact_form->form_scan_shortcode(
		array( 'type' => array( 'file', 'file*' ) ) );

	if ( ! $has_tags )
		return;

	$uploads_dir = wpef7_upload_tmp_dir();
	wpef7_init_uploads();

	if ( ! is_dir( $uploads_dir ) || ! is_writable( $uploads_dir ) ) {
		$message = sprintf( __( 'This contact form contains file uploading fields, but the temporary folder for the files (%s) does not exist or is not writable. You can create the folder or change its permission manually.', 'wpef7' ), $uploads_dir );

		echo '<div class="error"><p><strong>' . esc_html( $message ) . '</strong></p></div>';
	}
}


/* File uploading functions */

function wpef7_init_uploads() {
	$dir = wpef7_upload_tmp_dir();
	wp_mkdir_p( trailingslashit( $dir ) );
	@chmod( $dir, 0733 );

	$htaccess_file = trailingslashit( $dir ) . '.htaccess';
	if ( file_exists( $htaccess_file ) )
		return;

	if ( $handle = @fopen( $htaccess_file, 'w' ) ) {
		fwrite( $handle, "Deny from all\n" );
		fclose( $handle );
	}
}

function wpef7_upload_tmp_dir() {
	if ( defined( 'WPEF7_UPLOADS_TMP_DIR' ) )
		return WPEF7_UPLOADS_TMP_DIR;
	else
		return wpef7_upload_dir( 'dir' ) . '/wpef7_uploads';
}

function wpef7_cleanup_upload_files() {
	$dir = trailingslashit( wpef7_upload_tmp_dir() );

	if ( ! is_dir( $dir ) )
		return false;
	if ( ! is_readable( $dir ) )
		return false;
	if ( ! is_writable( $dir ) )
		return false;

	if ( $handle = @opendir( $dir ) ) {
		while ( false !== ( $file = readdir( $handle ) ) ) {
			if ( $file == "." || $file == ".." || $file == ".htaccess" )
				continue;

			$stat = stat( $dir . $file );
			if ( $stat['mtime'] + 60 < time() ) // 60 secs
				@unlink( $dir . $file );
		}
		closedir( $handle );
	}
}

if ( ! is_admin() && 'GET' == $_SERVER['REQUEST_METHOD'] )
	wpef7_cleanup_upload_files();

?>