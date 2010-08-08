<?php
/**
** A base module for [text], [text*], [email], and [email*]
**/

/* Shortcode handler */

wpef7_add_shortcode( 'text', 'wpef7_text_shortcode_handler', true );
wpef7_add_shortcode( 'text*', 'wpef7_text_shortcode_handler', true );
wpef7_add_shortcode( 'email', 'wpef7_text_shortcode_handler', true );
wpef7_add_shortcode( 'email*', 'wpef7_text_shortcode_handler', true );

function wpef7_text_shortcode_handler( $tag ) {
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
	$size_att = '';
	$maxlength_att = '';
	$tabindex_att = '';

	$class_att .= ' wpef7-text';

	if ( 'email' == $type || 'email*' == $type )
		$class_att .= ' wpef7-validates-as-email';

	if ( 'text*' == $type || 'email*' == $type )
		$class_att .= ' wpef7-validates-as-required';

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

	if ( $size_att )
		$atts .= ' size="' . $size_att . '"';
	else
		$atts .= ' size="40"'; // default size

	if ( $maxlength_att )
		$atts .= ' maxlength="' . $maxlength_att . '"';

	if ( '' !== $tabindex_att )
		$atts .= sprintf( ' tabindex="%d"', $tabindex_att );

	// Value
	if ( is_a( $wpef7_contact_form, 'WPEF7_ContactForm' ) && $wpef7_contact_form->is_posted() ) {
		if ( isset( $_POST['_wpef7_mail_sent'] ) && $_POST['_wpef7_mail_sent']['ok'] )
			$value = '';
		else
			$value = stripslashes_deep( $_POST[$name] );
	} else {
		$value = isset( $values[0] ) ? $values[0] : '';
	}

	$html = '<input type="text" name="' . $name . '" value="' . esc_attr( $value ) . '"' . $atts . ' />';

	$validation_error = '';
	if ( is_a( $wpef7_contact_form, 'WPEF7_ContactForm' ) )
		$validation_error = $wpef7_contact_form->validation_error( $name );

	$html = '<span class="wpef7-form-control-wrap ' . $name . '">' . $html . $validation_error . '</span>';

	return $html;
}


/* Validation filter */

add_filter( 'wpef7_validate_text', 'wpef7_text_validation_filter', 10, 2 );
add_filter( 'wpef7_validate_text*', 'wpef7_text_validation_filter', 10, 2 );
add_filter( 'wpef7_validate_email', 'wpef7_text_validation_filter', 10, 2 );
add_filter( 'wpef7_validate_email*', 'wpef7_text_validation_filter', 10, 2 );

function wpef7_text_validation_filter( $result, $tag ) {
	global $wpef7_contact_form;

	$type = $tag['type'];
	$name = $tag['name'];

	$_POST[$name] = trim( strtr( (string) $_POST[$name], "\n", " " ) );

	if ( 'text*' == $type ) {
		if ( '' == $_POST[$name] ) {
			$result['valid'] = false;
			$result['reason'][$name] = $wpef7_contact_form->message( 'invalid_required' );
		}
	}

	if ( 'email' == $type || 'email*' == $type ) {
		if ( 'email*' == $type && '' == $_POST[$name] ) {
			$result['valid'] = false;
			$result['reason'][$name] = $wpef7_contact_form->message( 'invalid_required' );
		} elseif ( '' != $_POST[$name] && ! is_email( $_POST[$name] ) ) {
			$result['valid'] = false;
			$result['reason'][$name] = $wpef7_contact_form->message( 'invalid_email' );
		}
	}

	return $result;
}


/* Tag generator */

add_action( 'admin_init', 'wpef7_add_tag_generator_text_and_email', 15 );

function wpef7_add_tag_generator_text_and_email() {
	wpef7_add_tag_generator( 'text', __( 'Text field', 'wpef7' ),
		'wpef7-tg-pane-text', 'wpef7_tg_pane_text' );

	wpef7_add_tag_generator( 'email', __( 'Email field', 'wpef7' ),
		'wpef7-tg-pane-email', 'wpef7_tg_pane_email' );
}

function wpef7_tg_pane_text( &$contact_form ) {
	wpef7_tg_pane_text_and_email( 'text' );
}

function wpef7_tg_pane_email( &$contact_form ) {
	wpef7_tg_pane_text_and_email( 'email' );
}

function wpef7_tg_pane_text_and_email( $type = 'text' ) {
	if ( 'email' != $type )
		$type = 'text';

?>
<div id="wpef7-tg-pane-<?php echo $type; ?>" class="hidden">
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
<td><code>size</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="size" class="numeric oneline option" /></td>

<td><code>maxlength</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="maxlength" class="numeric oneline option" /></td>
</tr>

<tr>
<td><?php echo esc_html( __( 'Akismet', 'wpef7' ) ); ?> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<?php if ( 'text' == $type ) : ?>
<input type="checkbox" name="akismet:author" class="exclusive option" />&nbsp;<?php echo esc_html( __( "This field requires author's name", 'wpef7' ) ); ?><br />
<input type="checkbox" name="akismet:author_url" class="exclusive option" />&nbsp;<?php echo esc_html( __( "This field requires author's URL", 'wpef7' ) ); ?>
<?php else : ?>
<input type="checkbox" name="akismet:author_email" class="option" />&nbsp;<?php echo esc_html( __( "This field requires author's email address", 'wpef7' ) ); ?>
<?php endif; ?>
</td>

<td><?php echo esc_html( __( 'Default value', 'wpef7' ) ); ?> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br /><input type="text" name="values" class="oneline" /></td>
</tr>
</table>

<div class="tg-tag"><?php echo esc_html( __( "Copy this code and paste it into the form left.", 'wpef7' ) ); ?><br /><input type="text" name="<?php echo $type; ?>" class="tag" readonly="readonly" onfocus="this.select()" /></div>

<div class="tg-mail-tag"><?php echo esc_html( __( "And, put this code into the Mail fields below.", 'wpef7' ) ); ?><br /><span class="arrow">&#11015;</span>&nbsp;<input type="text" class="mail-tag" readonly="readonly" onfocus="this.select()" /></div>
</form>
</div>
<?php
}

?>