<?php
/*
Plugin Name: Eval Form 7
Plugin URI: http://simcop2387.info/
Description: Just another contact form plugin mangled into an evaluation form for Farnsworth. Simple but flexible.
Author: Takayuki Miyoshi && Ryan Voots
Author URI: http://simcop2387.info/
Version: 2.3.1
*/

/*  Copyright 2007-2010 Takayuki Miyoshi (email: takayukister at gmail.com)
    Portions mangled by Ryan Voots to turn it into somethin god never inteded.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

define( 'WPEF7_VERSION', '2.3.1' );

if ( ! defined( 'WPEF7_PLUGIN_BASENAME' ) )
	define( 'WPEF7_PLUGIN_BASENAME', plugin_basename( __FILE__ ) );

if ( ! defined( 'WPEF7_PLUGIN_NAME' ) )
	define( 'WPEF7_PLUGIN_NAME', trim( dirname( WPEF7_PLUGIN_BASENAME ), '/' ) );

if ( ! defined( 'WPEF7_PLUGIN_DIR' ) )
	define( 'WPEF7_PLUGIN_DIR', WP_PLUGIN_DIR . '/' . WPEF7_PLUGIN_NAME );

if ( ! defined( 'WPEF7_PLUGIN_URL' ) )
	define( 'WPEF7_PLUGIN_URL', WP_PLUGIN_URL . '/' . WPEF7_PLUGIN_NAME );

if ( ! defined( 'WPEF7_PLUGIN_MODULES_DIR' ) )
	define( 'WPEF7_PLUGIN_MODULES_DIR', WPEF7_PLUGIN_DIR . '/modules' );

if ( ! defined( 'WPEF7_LOAD_JS' ) )
	define( 'WPEF7_LOAD_JS', true );

if ( ! defined( 'WPEF7_LOAD_CSS' ) )
	define( 'WPEF7_LOAD_CSS', true );

if ( ! defined( 'WPEF7_AUTOP' ) )
	define( 'WPEF7_AUTOP', true );

if ( ! defined( 'WPEF7_USE_PIPE' ) )
	define( 'WPEF7_USE_PIPE', true );

/* If you or your client hate to see about donation, set this value false. */
if ( ! defined( 'WPEF7_SHOW_DONATION_LINK' ) )
	define( 'WPEF7_SHOW_DONATION_LINK', true );

if ( ! defined( 'WPEF7_ADMIN_READ_CAPABILITY' ) )
	define( 'WPEF7_ADMIN_READ_CAPABILITY', 'edit_posts' );

if ( ! defined( 'WPEF7_ADMIN_READ_WRITE_CAPABILITY' ) )
	define( 'WPEF7_ADMIN_READ_WRITE_CAPABILITY', 'publish_pages' );

require_once WPEF7_PLUGIN_DIR . '/settings.php';

?>
