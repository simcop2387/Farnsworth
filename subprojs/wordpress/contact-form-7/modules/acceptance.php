<?php
/**
** A base module for [acceptance]
**/

/* Shortcode handler */

wpef7_add_shortcode( 'acceptance', 'wpef7_acceptance_shortcode_handler', true );

function wpef7_acceptance_shortcode_handler( $tag ) {
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

	$class_att .= ' wpef7-acceptance';

	foreach ( $options as $option ) {
		if ( preg_match( '%^id:([-0-9a-zA-Z_]+)$%', $option, $matches ) ) {
			$id_att = $matches[1];

		} elseif ( preg_match( '%^class:([-0-9a-zA-Z_]+)$%', $option, $matches ) ) {
			$class_att .= ' ' . $matches[1];

		} elseif ( 'invert' == $option ) {
			$class_att .= ' wpef7-invert';

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

	$default_on = (bool) preg_grep( '/^default:on$/i', $options );

	if ( wpef7_script_is() )
		$onclick = ' onclick="wpef7ToggleSubmit(this.form);"';
	else
		$onclick = '';

	$checked = $default_on ? ' checked="checked"' : '';

	$html = '<input type="checkbox" name="' . $name . '" value="1"' . $atts . $onclick . $checked . ' />';

	return $html;
}


/* Acceptance filter */

add_filter( 'wpef7_acceptance', 'wpef7_acceptance_filter' );

function wpef7_acceptance_filter( $accepted ) {
	global $wpef7_contact_form;

	$fes = $wpef7_contact_form->form_scan_shortcode( array( 'type' => 'acceptance' ) );

	foreach ( $fes as $fe ) {
		$name = $fe['name'];
		$options = (array) $fe['options'];

		if ( empty( $name ) )
			continue;

		$value = $_POST[$name] ? 1 : 0;

		$invert = (bool) preg_grep( '%^invert$%', $options );

		if ( $invert && $value || ! $invert && ! $value )
			$accepted = false;
	}

	return $accepted;
}


/* Tag generator */

add_action( 'admin_init', 'wpef7_add_tag_generator_acceptance', 35 );

function wpef7_add_tag_generator_acceptance() {
	wpef7_add_tag_generator( 'acceptance', __( 'Acceptance', 'wpef7' ),
		'wpef7-tg-pane-acceptance', 'wpef7_tg_pane_acceptance' );
}

function wpef7_tg_pane_acceptance( &$contact_form ) {
?>
<div id="wpef7-tg-pane-acceptance" class="hidden">
<form action="">
<table>
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
<td colspan="2">
<br /><input type="checkbox" name="default:on" class="option" />&nbsp;<?php echo esc_html( __( "Make this checkbox checked by default?", 'wpef7' ) ); ?>
<br /><input type="checkbox" name="invert" class="option" />&nbsp;<?php echo esc_html( __( "Make this checkbox work inversely?", 'wpef7' ) ); ?>
<br /><span style="font-size: smaller;"><?php echo esc_html( __( "* That means visitor who accepts the term unchecks it.", 'wpef7' ) ); ?></span>
</td>
</tr>
</table>

<div class="tg-tag"><?php echo esc_html( __( "Copy this code and paste it into the form left.", 'wpef7' ) ); ?><br /><input type="text" name="acceptance" class="tag" readonly="readonly" onfocus="this.select()" /></div>
</form>
</div>
<?php
}

?>