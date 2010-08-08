<?php

add_action( 'init', 'wpef7_init_switch', 11 );

function wpef7_init_switch() {
	if ( 'GET' == $_SERVER['REQUEST_METHOD'] && isset( $_GET['_wpef7_is_ajax_call'] ) ) {
		wpef7_ajax_onload();
		exit();
	} elseif ( 'POST' == $_SERVER['REQUEST_METHOD'] && isset( $_POST['_wpef7_is_ajax_call'] ) ) {
		wpef7_ajax_json_echo();
		exit();
	} elseif ( isset( $_POST['_wpef7'] ) ) {
		wpef7_process_nonajax_submitting();
	}
}

function wpef7_ajax_onload() {
	global $wpef7_contact_form;

	$echo = '';

	if ( isset( $_GET['_wpef7'] ) ) {
		$id = (int) $_GET['_wpef7'];

		if ( $wpef7_contact_form = wpef7_contact_form( $id ) ) {
			$items = apply_filters( 'wpef7_ajax_onload', array() );
			$wpef7_contact_form = null;
		}
	}

	$echo = json_encode( $items );

	if ( $_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest' ) {
		@header( 'Content-Type: application/json; charset=' . get_option( 'blog_charset' ) );
		echo $echo;
	}
}

function wpef7_ajax_json_echo() {
	global $wpef7_contact_form;

	$echo = '';

	if ( isset( $_POST['_wpef7'] ) ) {
		$id = (int) $_POST['_wpef7'];
		$unit_tag = $_POST['_wpef7_unit_tag'];

		if ( $wpef7_contact_form = wpef7_contact_form( $id ) ) {
			$validation = $wpef7_contact_form->validate();

			$items = array(
				'mailSent' => false,
				'into' => '#' . $unit_tag,
				'captcha' => null );

			$items = apply_filters( 'wpef7_ajax_json_echo', $items );

			if ( ! $validation['valid'] ) { // Validation error occured
				$invalids = array();
				foreach ( $validation['reason'] as $name => $reason ) {
					$invalids[] = array(
						'into' => 'span.wpef7-form-control-wrap.' . $name,
						'message' => $reason );
				}

				$items['message'] = $wpef7_contact_form->message( 'validation_error' );
				$items['invalids'] = $invalids;

			} elseif ( ! $wpef7_contact_form->accepted() ) { // Not accepted terms
				$items['message'] = $wpef7_contact_form->message( 'accept_terms' );

			} elseif ( $wpef7_contact_form->mail() ) {
				$items['mailSent'] = true;
				$items['message'] = $wpef7_contact_form->omgresponse();

				$on_sent_ok = $wpef7_contact_form->additional_setting( 'on_sent_ok', false );
				if ( ! empty( $on_sent_ok ) ) {
					$on_sent_ok = array_map( 'wpef7_strip_quote', $on_sent_ok );
				} else {
					$on_sent_ok = null;
				}
				$items['onSentOk'] = $on_sent_ok;

				do_action_ref_array( 'wpef7_mail_sent', array( &$wpef7_contact_form ) );

			} else {
				$items['message'] = $wpef7_contact_form->message( 'mail_sent_ng' );
			}

			// remove upload files
			foreach ( (array) $wpef7_contact_form->uploaded_files as $name => $path ) {
				@unlink( $path );
			}

			$wpef7_contact_form = null;
		}
	}

	$echo = json_encode( $items );

	if ( $_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest' ) {
		@header( 'Content-Type: application/json; charset=' . get_option( 'blog_charset' ) );
		echo $echo;
	} else {
		@header( 'Content-Type: text/html; charset=' . get_option( 'blog_charset' ) );
		echo '<textarea>' . $echo . '</textarea>';
	}
}

function wpef7_process_nonajax_submitting() {
	global $wpef7_contact_form;

	if ( ! isset($_POST['_wpef7'] ) )
		return;

	$id = (int) $_POST['_wpef7'];

	if ( $wpef7_contact_form = wpef7_contact_form( $id ) ) {
		$validation = $wpef7_contact_form->validate();

		if ( ! $validation['valid'] ) {
			$_POST['_wpef7_validation_errors'] = array( 'id' => $id, 'messages' => $validation['reason'] );
		} elseif ( ! $wpef7_contact_form->accepted() ) { // Not accepted terms
			$_POST['_wpef7_mail_sent'] = array( 'id' => $id, 'ok' => false, 'message' => $wpef7_contact_form->message( 'accept_terms' ) );
		} elseif ( $wpef7_contact_form->mail() ) {
			$_POST['_wpef7_mail_sent'] = array( 'id' => $id, 'ok' => true, 'message' => $wpef7_contact_form->omgresponse() );

			do_action_ref_array( 'wpef7_mail_sent', array( &$wpef7_contact_form ) );
		} else {
			$_POST['_wpef7_mail_sent'] = array( 'id' => $id, 'ok' => false, 'message' => $wpef7_contact_form->message( 'mail_sent_ng' ) );
		}

		// remove upload files
		foreach ( (array) $wpef7_contact_form->uploaded_files as $name => $path ) {
			@unlink( $path );
		}

		$wpef7_contact_form = null;
	}
}

add_action( 'the_post', 'wpef7_the_post' );

function wpef7_the_post() {
	global $wpef7;

	$wpef7->processing_within = 'p' . get_the_ID();
	$wpef7->unit_count = 0;
}

add_action( 'loop_end', 'wpef7_loop_end' );

function wpef7_loop_end() {
	global $wpef7;

	$wpef7->processing_within = '';
}

add_filter( 'widget_text', 'wpef7_widget_text_filter', 9 );

function wpef7_widget_text_filter( $content ) {
	global $wpef7;

	$wpef7->widget_count += 1;
	$wpef7->processing_within = 'w' . $wpef7->widget_count;
	$wpef7->unit_count = 0;

	$regex = '/\[\s*eval-form\s+(\d+(?:\s+.*)?)\]/';
	$content = preg_replace_callback( $regex, 'wpef7_widget_text_filter_callback', $content );

	$wpef7->processing_within = '';
	return $content;
}

function wpef7_widget_text_filter_callback( $matches ) {
	return do_shortcode( $matches[0] );
}

add_shortcode( 'eval-form', 'wpef7_contact_form_tag_func' );

function wpef7_contact_form_tag_func( $atts ) {
	global $wpef7, $wpef7_contact_form;

	if ( is_feed() )
		return '[eval-form]';

	if ( is_string( $atts ) )
		$atts = explode( ' ', $atts, 2 );

	$atts = (array) $atts;

	$id = (int) array_shift( $atts );

	if ( ! ( $wpef7_contact_form = wpef7_contact_form( $id ) ) )
		return '[eval-form 404 "Not Found"]';

	if ( $wpef7->processing_within ) { // Inside post content or text widget
		$wpef7->unit_count += 1;
		$unit_count = $wpef7->unit_count;
		$processing_within = $wpef7->processing_within;

	} else { // Inside template

		if ( ! isset( $wpef7->global_unit_count ) )
			$wpef7->global_unit_count = 0;

		$wpef7->global_unit_count += 1;
		$unit_count = 1;
		$processing_within = 't' . $wpef7->global_unit_count;
	}

	$unit_tag = 'wpef7-f' . $id . '-' . $processing_within . '-o' . $unit_count;
	$wpef7_contact_form->unit_tag = $unit_tag;

	$form = $wpef7_contact_form->form_html();

	$wpef7_contact_form = null;

	return $form;
}

add_action( 'wp_head', 'wpef7_head' );

function wpef7_head() {
	// Cached?
	if ( wpef7_script_is() && defined( 'WP_CACHE' ) && WP_CACHE ) :
?>
<script type="text/javascript">
//<![CDATA[
var _wpef7 = { cached: 1 };
//]]>
</script>
<?php
	endif;
}

if ( WPEF7_LOAD_JS )
	add_action( 'wp_print_scripts', 'wpef7_enqueue_scripts' );

function wpef7_enqueue_scripts() {
	$in_footer = true;
	if ( 'header' === WPEF7_LOAD_JS )
		$in_footer = false;

	wp_enqueue_script( 'eval-form-7', wpef7_plugin_url( 'scripts.js' ),
		array( 'jquery', 'jquery-form' ), WPEF7_VERSION, $in_footer );

	do_action( 'wpef7_enqueue_scripts' );
}

function wpef7_script_is() {
	return wp_script_is( 'eval-form-7' );
}

if ( WPEF7_LOAD_CSS )
	add_action( 'wp_print_styles', 'wpef7_enqueue_styles' );

function wpef7_enqueue_styles() {
	wp_enqueue_style( 'eval-form-7', wpef7_plugin_url( 'styles.css' ),
		array(), WPEF7_VERSION, 'all' );

	if ( 'rtl' == get_bloginfo( 'text_direction' ) ) {
		wp_enqueue_style( 'eval-form-7-rtl', wpef7_plugin_url( 'styles-rtl.css' ),
			array(), WPEF7_VERSION, 'all' );
	}

	do_action( 'wpef7_enqueue_styles' );
}

function wpef7_style_is() {
	return wp_style_is( 'eval-form-7' );
}

?>