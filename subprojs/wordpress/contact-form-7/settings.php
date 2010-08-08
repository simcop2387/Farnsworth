<?php

function wpef7_plugin_path( $path = '' ) {
	return path_join( WPEF7_PLUGIN_DIR, trim( $path, '/' ) );
}

function wpef7_plugin_url( $path = '' ) {
	return plugins_url( $path, WPEF7_PLUGIN_BASENAME );
}

function wpef7_admin_url( $query = array() ) {
	global $plugin_page;

	if ( ! isset( $query['page'] ) )
		$query['page'] = $plugin_page;

	$path = 'admin.php';

	if ( $query = build_query( $query ) )
		$path .= '?' . $query;

	$url = admin_url( $path );

	return esc_url_raw( $url );
}

function wpef7_table_exists( $table = 'contactforms' ) {
	global $wpdb, $wpef7;

	if ( 'contactforms' != $table )
		return false;

	if ( ! $table = $wpef7->{$table} )
		return false;

	return strtolower( $wpdb->get_var( "SHOW TABLES LIKE '$table'" ) ) == strtolower( $table );
}

function wpef7() {
	global $wpdb, $wpef7;

	if ( is_object( $wpef7 ) )
		return;

	$wpef7 = (object) array(
		'contactforms' => $wpdb->prefix . "contact_form_7",
		'processing_within' => '',
		'widget_count' => 0,
		'unit_count' => 0,
		'global_unit_count' => 0 );
}

wpef7();

require_once WPEF7_PLUGIN_DIR . '/includes/functions.php';
require_once WPEF7_PLUGIN_DIR . '/includes/formatting.php';
require_once WPEF7_PLUGIN_DIR . '/includes/pipe.php';
require_once WPEF7_PLUGIN_DIR . '/includes/shortcodes.php';
require_once WPEF7_PLUGIN_DIR . '/includes/classes.php';
require_once WPEF7_PLUGIN_DIR . '/includes/taggenerator.php';

if ( is_admin() )
	require_once WPEF7_PLUGIN_DIR . '/admin/admin.php';
else
	require_once WPEF7_PLUGIN_DIR . '/includes/controller.php';

function wpef7_contact_forms() {
	global $wpdb, $wpef7;

	return $wpdb->get_results( "SELECT cf7_unit_id as id, title FROM $wpef7->contactforms" );
}

add_action( 'plugins_loaded', 'wpef7_set_request_uri', 9 );

function wpef7_set_request_uri() {
	global $wpef7_request_uri;

	$wpef7_request_uri = add_query_arg( array() );
}

function wpef7_get_request_uri() {
	global $wpef7_request_uri;

	return (string) $wpef7_request_uri;
}

/* Loading modules */

add_action( 'plugins_loaded', 'wpef7_load_modules', 1 );

function wpef7_load_modules() {
	$dir = WPEF7_PLUGIN_MODULES_DIR;

	if ( ! ( is_dir( $dir ) && $dh = opendir( $dir ) ) )
		return false;

	while ( ( $module = readdir( $dh ) ) !== false ) {
		if ( substr( $module, -4 ) == '.php' )
			include_once $dir . '/' . $module;
	}
}

/* L10N */

add_action( 'init', 'wpef7_load_plugin_textdomain' );

function wpef7_load_plugin_textdomain() {
	load_plugin_textdomain( 'wpef7', false, 'eval-form-7/languages' );
}

?>