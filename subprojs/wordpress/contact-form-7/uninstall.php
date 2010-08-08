<?php

if ( ! defined( 'WP_UNINSTALL_PLUGIN' ) )
	exit();

function wpef7_delete_plugin() {
	global $wpdb;

	delete_option( 'wpef7' );

	$table_name = $wpdb->prefix . "contact_form_7";

	$wpdb->query( "DROP TABLE IF EXISTS $table_name" );
}

wpef7_delete_plugin();

?>