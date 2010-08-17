<?php
/**
** A base module for [submit]
**/

/* Shortcode handler */

wpef7_add_shortcode( 'submit', 'wpef7_submit_shortcode_handler' );

function wpef7_submit_shortcode_handler( $tag ) {
	if ( ! is_array( $tag ) )
		return '';

	$options = (array) $tag['options'];
	$values = (array) $tag['values'];

	$atts = '';
	$id_att = '';
	$class_att = '';
	$tabindex_att = '';

	$class_att .= ' wpef7-submit';

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

	$value = isset( $values[0] ) ? $values[0] : '';
	if ( empty( $value ) )
		$value = __( 'Send', 'wpef7' );

	$html = '<input type="submit" value="' . esc_attr( $value ) . '"' . $atts . ' />';

	if ( wpef7_script_is() ) {
		$src = apply_filters( 'wpef7_ajax_loader', wpef7_plugin_url( 'images/ajax-loader.gif' ) );
		$html .= '<img class="ajax-loader" style="visibility: hidden;" alt="' . esc_attr( __( 'Sending ...', 'wpef7' ) ) . '" src="' . esc_url_raw( $src ) . '" />';
	}

	return $html;
}


/* Tag generator */

add_action( 'admin_init', 'wpef7_add_tag_generator_submit', 55 );

function wpef7_add_tag_generator_submit() {
	wpef7_add_tag_generator( 'submit', __( 'Submit button', 'wpef7' ),
		'wpef7-tg-pane-submit', 'wpef7_tg_pane_submit', array( 'nameless' => 1 ) );
}

function wpef7_tg_pane_submit( &$contact_form ) {
?>
<div id="wpef7-tg-pane-submit" class="hidden">
<form action="">
<table>
<tr>
<td><code>id</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="id" class="idvalue oneline option" /></td>

<td><code>class</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="class" class="classvalue oneline option" /></td>
</tr>

<tr>
<td><?php echo esc_html( __( 'Label', 'wpef7' ) ); ?> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="values" class="oneline" /></td>

<td></td>
</tr>
</table>

<div class="tg-tag"><?php echo esc_html( __( "Copy this code and paste it into the form left.", 'wpef7' ) ); ?><br /><input type="text" name="submit" class="tag" readonly="readonly" onfocus="this.select()" /></div>
</form>
</div>
<?php
}

?>