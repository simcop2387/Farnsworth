<?php
/**
** A base module for [captchac] and [captchar]
**/

/* Shortcode handler */

wpef7_add_shortcode( 'captchac', 'wpef7_captcha_shortcode_handler', true );
wpef7_add_shortcode( 'captchar', 'wpef7_captcha_shortcode_handler', true );

function wpef7_captcha_shortcode_handler( $tag ) {
	global $wpef7_contact_form;

	if ( ! is_array( $tag ) )
		return '';

	$type = $tag['type'];
	$name = $tag['name'];
	$options = (array) $tag['options'];
	$values = (array) $tag['values'];

	if ( empty( $name ) )
		return '';

	$validation_error = '';
	if ( is_a( $wpef7_contact_form, 'WPEF7_ContactForm' ) )
		$validation_error = $wpef7_contact_form->validation_error( $name );

	$atts = '';
	$id_att = '';
	$class_att = '';
	$size_att = '';
	$maxlength_att = '';
	$tabindex_att = '';

	if ( 'captchac' == $type )
		$class_att .= ' wpef7-captcha-' . $name;

	foreach ( $options as $option ) {
		if ( preg_match( '%^id:([-0-9a-zA-Z_]+)$%', $option, $matches ) ) {
			$id_att = $matches[1];

		} elseif ( preg_match( '%^class:([-0-9a-zA-Z_]+)$%', $option, $matches ) ) {
			$class_att .= ' ' . $matches[1];

		} elseif ( preg_match( '%^([0-9]*)[/x]([0-9]*)$%', $option, $matches ) ) {
			$size_att = (int) $matches[1];
			$maxlength_att = (int) $matches[2];

		} elseif ( preg_match( '%^tabindex:(\d+)$%', $option, $matches ) ) {
			$tabindex_att = (int) $matches[1];

		}
	}

	if ( $id_att )
		$atts .= ' id="' . trim( $id_att ) . '"';

	if ( $class_att )
		$atts .= ' class="' . trim( $class_att ) . '"';

	// Value.
	if ( is_a( $wpef7_contact_form, 'WPEF7_ContactForm' ) && $wpef7_contact_form->is_posted() )
		$value = '';
	else
		$value = $values[0];

	if ( 'captchac' == $type ) {
		if ( ! class_exists( 'ReallySimpleCaptcha' ) ) {
			return '<em>' . __( 'To use CAPTCHA, you need <a href="http://wordpress.org/extend/plugins/really-simple-captcha/">Really Simple CAPTCHA</a> plugin installed.', 'wpef7' ) . '</em>';
		}

		$op = array();
		// Default
		$op['img_size'] = array( 72, 24 );
		$op['base'] = array( 6, 18 );
		$op['font_size'] = 14;
		$op['font_char_width'] = 15;

		$op = array_merge( $op, wpef7_captchac_options( $options ) );

		if ( ! $filename = wpef7_generate_captcha( $op ) )
			return '';

		if ( is_array( $op['img_size'] ) )
			$atts .= ' width="' . $op['img_size'][0] . '" height="' . $op['img_size'][1] . '"';

		$captcha_url = trailingslashit( wpef7_captcha_tmp_url() ) . $filename;
		$html = '<img alt="captcha" src="' . $captcha_url . '"' . $atts . ' />';
		$ref = substr( $filename, 0, strrpos( $filename, '.' ) );
		$html = '<input type="hidden" name="_wpef7_captcha_challenge_' . $name . '" value="' . $ref . '" />' . $html;

		return $html;

	} elseif ( 'captchar' == $type ) {
		if ( $size_att )
			$atts .= ' size="' . $size_att . '"';
		else
			$atts .= ' size="40"'; // default size

		if ( $maxlength_att )
			$atts .= ' maxlength="' . $maxlength_att . '"';

		if ( '' !== $tabindex_att )
			$atts .= sprintf( ' tabindex="%d"', $tabindex_att );

		$html = '<input type="text" name="' . $name . '" value="' . esc_attr( $value ) . '"' . $atts . ' />';
		$html = '<span class="wpef7-form-control-wrap ' . $name . '">' . $html . $validation_error . '</span>';

		return $html;
	}
}


/* Validation filter */

add_filter( 'wpef7_validate_captchar', 'wpef7_captcha_validation_filter', 10, 2 );

function wpef7_captcha_validation_filter( $result, $tag ) {
	global $wpef7_contact_form;

	$type = $tag['type'];
	$name = $tag['name'];

	$_POST[$name] = (string) $_POST[$name];

	$captchac = '_wpef7_captcha_challenge_' . $name;

	if ( ! wpef7_check_captcha( $_POST[$captchac], $_POST[$name] ) ) {
		$result['valid'] = false;
		$result['reason'][$name] = $wpef7_contact_form->message( 'captcha_not_match' );
	}

	wpef7_remove_captcha( $_POST[$captchac] );

	return $result;
}


/* Ajax echo filter */

add_filter( 'wpef7_ajax_onload', 'wpef7_captcha_ajax_refill' );
add_filter( 'wpef7_ajax_json_echo', 'wpef7_captcha_ajax_refill' );

function wpef7_captcha_ajax_refill( $items ) {
	global $wpef7_contact_form;

	if ( ! is_a( $wpef7_contact_form, 'WPEF7_ContactForm' ) )
		return $items;

	if ( ! is_array( $items ) )
		return $items;

	$fes = $wpef7_contact_form->form_scan_shortcode(
		array( 'type' => 'captchac' ) );

	if ( empty( $fes ) )
		return $items;

	$refill = array();

	foreach ( $fes as $fe ) {
		$name = $fe['name'];
		$options = $fe['options'];

		if ( empty( $name ) )
			continue;

		$op = wpef7_captchac_options( $options );
		if ( $filename = wpef7_generate_captcha( $op ) ) {
			$captcha_url = trailingslashit( wpef7_captcha_tmp_url() ) . $filename;
			$refill[$name] = $captcha_url;
		}
	}

	if ( ! empty( $refill ) )
		$items['captcha'] = $refill;

	return $items;
}


/* Messages */

add_filter( 'wpef7_messages', 'wpef7_captcha_messages' );

function wpef7_captcha_messages( $messages ) {
	return array_merge( $messages, array( 'captcha_not_match' => array(
		'description' => __( "The code that sender entered does not match the CAPTCHA", 'wpef7' ),
		'default' => __( 'Your entered code is incorrect.', 'wpef7' )
	) ) );
}


/* Tag generator */

add_action( 'admin_init', 'wpef7_add_tag_generator_captcha', 45 );

function wpef7_add_tag_generator_captcha() {
	wpef7_add_tag_generator( 'captcha', __( 'CAPTCHA', 'wpef7' ),
		'wpef7-tg-pane-captcha', 'wpef7_tg_pane_captcha' );
}

function wpef7_tg_pane_captcha( &$contact_form ) {
?>
<div id="wpef7-tg-pane-captcha" class="hidden">
<form action="">
<table>

<?php if ( ! class_exists( 'ReallySimpleCaptcha' ) ) : ?>
<tr><td colspan="2"><strong style="color: #e6255b"><?php echo esc_html( __( "Note: To use CAPTCHA, you need Really Simple CAPTCHA plugin installed.", 'wpef7' ) ); ?></strong><br /><a href="http://wordpress.org/extend/plugins/really-simple-captcha/">http://wordpress.org/extend/plugins/really-simple-captcha/</a></td></tr>
<?php endif; ?>

<tr><td><?php echo esc_html( __( 'Name', 'wpef7' ) ); ?><br /><input type="text" name="name" class="tg-name oneline" /></td><td></td></tr>
</table>

<table class="scope captchac">
<caption><?php echo esc_html( __( "Image settings", 'wpef7' ) ); ?></caption>

<tr>
<td><code>id</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="id" class="idvalue oneline option" /></td>

<td><code>class</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="class" class="classvalue oneline option" /></td>
</tr>

<tr>
<td><?php echo esc_html( __( "Foreground color", 'wpef7' ) ); ?> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="fg" class="color oneline option" /></td>

<td><?php echo esc_html( __( "Background color", 'wpef7' ) ); ?> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="bg" class="color oneline option" /></td>
</tr>

<tr><td colspan="2"><?php echo esc_html( __( "Image size", 'wpef7' ) ); ?> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="checkbox" name="size:s" class="exclusive option" />&nbsp;<?php echo esc_html( __( "Small", 'wpef7' ) ); ?>&emsp;
<input type="checkbox" name="size:m" class="exclusive option" />&nbsp;<?php echo esc_html( __( "Medium", 'wpef7' ) ); ?>&emsp;
<input type="checkbox" name="size:l" class="exclusive option" />&nbsp;<?php echo esc_html( __( "Large", 'wpef7' ) ); ?>
</td></tr>
</table>

<table class="scope captchar">
<caption><?php echo esc_html( __( "Input field settings", 'wpef7' ) ); ?></caption>

<tr>
<td><code>id</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="id" class="idvalue oneline option" /></td>

<td><code>class</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="class" class="classvalue oneline option" /></td>
</tr>

<tr>
<td><code>size</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="size" class="numeric oneline option" /></td>

<td><code>maxlength</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="maxlength" class="numeric oneline option" /></td>
</tr>
</table>

<div class="tg-tag"><?php echo esc_html( __( "Copy this code and paste it into the form left.", 'wpef7' ) ); ?>
<br />1) <?php echo esc_html( __( "For image", 'wpef7' ) ); ?>
<input type="text" name="captchac" class="tag" readonly="readonly" onfocus="this.select()" />
<br />2) <?php echo esc_html( __( "For input field", 'wpef7' ) ); ?>
<input type="text" name="captchar" class="tag" readonly="readonly" onfocus="this.select()" />
</div>
</form>
</div>
<?php
}


/* Warning message */

add_action( 'wpef7_admin_before_subsubsub', 'wpef7_captcha_display_warning_message' );

function wpef7_captcha_display_warning_message( &$contact_form ) {
	if ( ! $contact_form )
		return;

	$has_tags = (bool) $contact_form->form_scan_shortcode(
		array( 'type' => array( 'captchac' ) ) );

	if ( ! $has_tags )
		return;

	if ( ! class_exists( 'ReallySimpleCaptcha' ) )
		return;

	$uploads_dir = wpef7_captcha_tmp_dir();
	wpef7_init_captcha();

	if ( ! is_dir( $uploads_dir ) || ! is_writable( $uploads_dir ) ) {
		$message = sprintf( __( 'This contact form contains CAPTCHA fields, but the temporary folder for the files (%s) does not exist or is not writable. You can create the folder or change its permission manually.', 'wpef7' ), $uploads_dir );

		echo '<div class="error"><p><strong>' . esc_html( $message ) . '</strong></p></div>';
	}

	if ( ! function_exists( 'imagecreatetruecolor' ) || ! function_exists( 'imagettftext' ) ) {
		$message = __( 'This contact form contains CAPTCHA fields, but the necessary libraries (GD and FreeType) are not available on your server.', 'wpef7' );

		echo '<div class="error"><p><strong>' . esc_html( $message ) . '</strong></p></div>';
	}
}


/* CAPTCHA functions */

function wpef7_init_captcha() {
	global $wpef7_captcha;

	if ( ! class_exists( 'ReallySimpleCaptcha' ) )
		return false;

	if ( ! is_object( $wpef7_captcha ) )
		$wpef7_captcha = new ReallySimpleCaptcha();
	$captcha =& $wpef7_captcha;

	$captcha->tmp_dir = trailingslashit( wpef7_captcha_tmp_dir() );
	wp_mkdir_p( $captcha->tmp_dir );
	return true;
}

function wpef7_captcha_tmp_dir() {
	if ( defined( 'WPEF7_CAPTCHA_TMP_DIR' ) )
		return WPEF7_CAPTCHA_TMP_DIR;
	else
		return wpef7_upload_dir( 'dir' ) . '/wpef7_captcha';
}

function wpef7_captcha_tmp_url() {
	if ( defined( 'WPEF7_CAPTCHA_TMP_URL' ) )
		return WPEF7_CAPTCHA_TMP_URL;
	else
		return wpef7_upload_dir( 'url' ) . '/wpef7_captcha';
}

function wpef7_generate_captcha( $options = null ) {
	global $wpef7_captcha;

	if ( ! wpef7_init_captcha() )
		return false;
	$captcha =& $wpef7_captcha;

	if ( ! is_dir( $captcha->tmp_dir ) || ! is_writable( $captcha->tmp_dir ) )
		return false;

	$img_type = imagetypes();
	if ( $img_type & IMG_PNG )
		$captcha->img_type = 'png';
	elseif ( $img_type & IMG_GIF )
		$captcha->img_type = 'gif';
	elseif ( $img_type & IMG_JPG )
		$captcha->img_type = 'jpeg';
	else
		return false;

	if ( is_array( $options ) ) {
		if ( isset( $options['img_size'] ) )
			$captcha->img_size = $options['img_size'];
		if ( isset( $options['base'] ) )
			$captcha->base = $options['base'];
		if ( isset( $options['font_size'] ) )
			$captcha->font_size = $options['font_size'];
		if ( isset( $options['font_char_width'] ) )
			$captcha->font_char_width = $options['font_char_width'];
		if ( isset( $options['fg'] ) )
			$captcha->fg = $options['fg'];
		if ( isset( $options['bg'] ) )
			$captcha->bg = $options['bg'];
	}

	$prefix = mt_rand();
	$captcha_word = $captcha->generate_random_word();
	return $captcha->generate_image( $prefix, $captcha_word );
}

function wpef7_check_captcha( $prefix, $response ) {
	global $wpef7_captcha;

	if ( ! wpef7_init_captcha() )
		return false;
	$captcha =& $wpef7_captcha;

	return $captcha->check( $prefix, $response );
}

function wpef7_remove_captcha( $prefix ) {
	global $wpef7_captcha;

	if ( ! wpef7_init_captcha() )
		return false;
	$captcha =& $wpef7_captcha;

	$captcha->remove( $prefix );
}

function wpef7_cleanup_captcha_files() {
	global $wpef7_captcha;

	if ( ! wpef7_init_captcha() )
		return false;
	$captcha =& $wpef7_captcha;

	if ( is_callable( array( $captcha, 'cleanup' ) ) )
		return $captcha->cleanup();

	$dir = trailingslashit( wpef7_captcha_tmp_dir() );

	if ( ! is_dir( $dir ) || ! is_readable( $dir ) || ! is_writable( $dir ) )
		return false;

	if ( $handle = @opendir( $dir ) ) {
		while ( false !== ( $file = readdir( $handle ) ) ) {
			if ( ! preg_match( '/^[0-9]+\.(php|png|gif|jpeg)$/', $file ) )
				continue;

			$stat = @stat( $dir . $file );
			if ( $stat['mtime'] + 3600 < time() ) // 3600 secs == 1 hour
				@unlink( $dir . $file );
		}
		closedir( $handle );
	}
}

if ( ! is_admin() && 'GET' == $_SERVER['REQUEST_METHOD'] )
	wpef7_cleanup_captcha_files();

function wpef7_captchac_options( $options ) {
	if ( ! is_array( $options ) )
		return array();

	$op = array();
	$image_size_array = preg_grep( '%^size:[smlSML]$%', $options );

	if ( $image_size = array_shift( $image_size_array ) ) {
		preg_match( '%^size:([smlSML])$%', $image_size, $is_matches );
		switch ( strtolower( $is_matches[1] ) ) {
			case 's':
				$op['img_size'] = array( 60, 20 );
				$op['base'] = array( 6, 15 );
				$op['font_size'] = 11;
				$op['font_char_width'] = 13;
				break;
			case 'l':
				$op['img_size'] = array( 84, 28 );
				$op['base'] = array( 6, 20 );
				$op['font_size'] = 17;
				$op['font_char_width'] = 19;
				break;
			case 'm':
			default:
				$op['img_size'] = array( 72, 24 );
				$op['base'] = array( 6, 18 );
				$op['font_size'] = 14;
				$op['font_char_width'] = 15;
		}
	}

	$fg_color_array = preg_grep( '%^fg:#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$%', $options );
	if ( $fg_color = array_shift( $fg_color_array ) ) {
		preg_match( '%^fg:#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$%', $fg_color, $fc_matches );
		if ( 3 == strlen( $fc_matches[1] ) ) {
			$r = substr( $fc_matches[1], 0, 1 );
			$g = substr( $fc_matches[1], 1, 1 );
			$b = substr( $fc_matches[1], 2, 1 );
			$op['fg'] = array( hexdec( $r . $r ), hexdec( $g . $g ), hexdec( $b . $b ) );
		} elseif ( 6 == strlen( $fc_matches[1] ) ) {
			$r = substr( $fc_matches[1], 0, 2 );
			$g = substr( $fc_matches[1], 2, 2 );
			$b = substr( $fc_matches[1], 4, 2 );
			$op['fg'] = array( hexdec( $r ), hexdec( $g ), hexdec( $b ) );
		}
	}

	$bg_color_array = preg_grep( '%^bg:#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$%', $options );
	if ( $bg_color = array_shift( $bg_color_array ) ) {
		preg_match( '%^bg:#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$%', $bg_color, $bc_matches );
		if ( 3 == strlen( $bc_matches[1] ) ) {
			$r = substr( $bc_matches[1], 0, 1 );
			$g = substr( $bc_matches[1], 1, 1 );
			$b = substr( $bc_matches[1], 2, 1 );
			$op['bg'] = array( hexdec( $r . $r ), hexdec( $g . $g ), hexdec( $b . $b ) );
		} elseif ( 6 == strlen( $bc_matches[1] ) ) {
			$r = substr( $bc_matches[1], 0, 2 );
			$g = substr( $bc_matches[1], 2, 2 );
			$b = substr( $bc_matches[1], 4, 2 );
			$op['bg'] = array( hexdec( $r ), hexdec( $g ), hexdec( $b ) );
		}
	}

	return $op;
}

$wpef7_captcha = null;

?>