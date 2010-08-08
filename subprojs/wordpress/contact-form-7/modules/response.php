<?php
/**
** A base module for [response]
**/

/* Shortcode handler */

wpef7_add_shortcode( 'response', 'wpef7_response_shortcode_handler' );

function wpef7_response_shortcode_handler( $tag ) {
	global $wpef7_contact_form;

	$wpef7_contact_form->responses_count += 1;
	return $wpef7_contact_form->form_response_output();
}

?>