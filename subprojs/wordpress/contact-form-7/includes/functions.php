<?php

function wpef7_messages() {
	$messages = array(
		'mail_sent_ok' => array(
			'description' => __( "Sender's message was sent successfully", 'wpef7' ),
			'default' => __( 'Your message was sent successfully. Thanks.', 'wpef7' )
		),

		'mail_sent_ng' => array(
			'description' => __( "Sender's message was failed to send", 'wpef7' ),
			'default' => __( 'Failed to send your message. Please try later or contact administrator by other way.', 'wpef7' )
		),

		'akismet_says_spam' => array(
			'description' => __( "Akismet judged the sending activity as spamming", 'wpef7' ),
			'default' => __( 'Failed to send your message. Please try later or contact administrator by other way.', 'wpef7' )
		),

		'validation_error' => array(
			'description' => __( "Validation errors occurred", 'wpef7' ),
			'default' => __( 'Validation errors occurred. Please confirm the fields and submit it again.', 'wpef7' )
		),

		'accept_terms' => array(
			'description' => __( "There is a field of term that sender is needed to accept", 'wpef7' ),
			'default' => __( 'Please accept the terms to proceed.', 'wpef7' )
		),

		'invalid_email' => array(
			'description' => __( "Email address that sender entered is invalid", 'wpef7' ),
			'default' => __( 'Email address seems invalid.', 'wpef7' )
		),

		'invalid_required' => array(
			'description' => __( "There is a field that sender is needed to fill in", 'wpef7' ),
			'default' => __( 'Please fill the required field.', 'wpef7' )
		)
	);

	return apply_filters( 'wpef7_messages', $messages );
}

function wpef7_default_form_template() {
	$template =
		'<p>' . __( 'Your Name', 'wpef7' ) . ' ' . __( '(required)', 'wpef7' ) . '<br />' . "\n"
		. '    [text* your-name] </p>' . "\n\n"
		. '<p>' . __( 'Your Email', 'wpef7' ) . ' ' . __( '(required)', 'wpef7' ) . '<br />' . "\n"
		. '    [email* your-email] </p>' . "\n\n"
		. '<p>' . __( 'Subject', 'wpef7' ) . '<br />' . "\n"
		. '    [text your-subject] </p>' . "\n\n"
		. '<p>' . __( 'Your Message', 'wpef7' ) . '<br />' . "\n"
		. '    [textarea your-message] </p>' . "\n\n"
		. '<p>[submit "' . __( 'Send', 'wpef7' ) . '"]</p>';

	return $template;
}

function wpef7_default_mail_template() {
	$subject = '[your-subject]';
	$sender = '[your-name] <[your-email]>';
	$body = sprintf( __( 'From: %s', 'wpef7' ), '[your-name] <[your-email]>' ) . "\n"
		. sprintf( __( 'Subject: %s', 'wpef7' ), '[your-subject]' ) . "\n\n"
		. __( 'Message Body:', 'wpef7' ) . "\n" . '[your-message]' . "\n\n" . '--' . "\n"
		. sprintf( __( 'This mail is sent via contact form on %1$s %2$s', 'wpef7' ),
			get_bloginfo( 'name' ), get_bloginfo( 'url' ) );
	$recipient = get_option( 'admin_email' );
	$additional_headers = '';
	$attachments = '';
	$use_html = 0;
	return compact( 'subject', 'sender', 'body', 'recipient', 'additional_headers', 'attachments', 'use_html' );
}

function wpef7_default_mail_2_template() {
	$active = false;
	$subject = '[your-subject]';
	$sender = '[your-name] <[your-email]>';
	$body = __( 'Message body:', 'wpef7' ) . "\n" . '[your-message]' . "\n\n" . '--' . "\n"
		. sprintf( __( 'This mail is sent via contact form on %1$s %2$s', 'wpef7' ),
			get_bloginfo( 'name' ), get_bloginfo( 'url' ) );
	$recipient = '[your-email]';
	$additional_headers = '';
	$attachments = '';
	$use_html = 0;
	return compact( 'active', 'subject', 'sender', 'body', 'recipient', 'additional_headers', 'attachments', 'use_html' );
}

function wpef7_default_messages_template() {
	$messages = array();

	foreach ( wpef7_messages() as $key => $arr ) {
		$messages[$key] = $arr['default'];
	}

	return $messages;
}

function wpef7_upload_dir( $type = false ) {
	$siteurl = get_option( 'siteurl' );
	$upload_path = trim( get_option( 'upload_path' ) );
	if ( empty( $upload_path ) )
		$dir = WP_CONTENT_DIR . '/uploads';
	else
		$dir = $upload_path;

	$dir = path_join( ABSPATH, $dir );

	if ( ! $url = get_option( 'upload_url_path' ) ) {
		if ( empty( $upload_path ) || $upload_path == $dir )
			$url = WP_CONTENT_URL . '/uploads';
		else
			$url = trailingslashit( $siteurl ) . $upload_path;
	}

	if ( defined( 'UPLOADS' ) ) {
		$dir = ABSPATH . UPLOADS;
		$url = trailingslashit( $siteurl ) . UPLOADS;
	}

	if ( 'dir' == $type )
		return $dir;
	if ( 'url' == $type )
		return $url;
	return array( 'dir' => $dir, 'url' => $url );
}

function wpef7_l10n() {
	$l10n = array(
		'af' => __( 'Afrikaans', 'wpef7' ),
		'sq' => __( 'Albanian', 'wpef7' ),
		'ar' => __( 'Arabic', 'wpef7' ),
		'bn_BD' => __( 'Bangla', 'wpef7' ),
		'bs' => __( 'Bosnian', 'wpef7' ),
		'pt_BR' => __( 'Brazilian Portuguese', 'wpef7' ),
		'bg_BG' => __( 'Bulgarian', 'wpef7' ),
		'ca' => __( 'Catalan', 'wpef7' ),
		'zh_CN' => __( 'Chinese (Simplified)', 'wpef7' ),
		'zh_TW' => __( 'Chinese (Traditional)', 'wpef7' ),
		'hr' => __( 'Croatian', 'wpef7' ),
		'cs_CZ' => __( 'Czech', 'wpef7' ),
		'da_DK' => __( 'Danish', 'wpef7' ),
		'nl_NL' => __( 'Dutch', 'wpef7' ),
		'en_US' => __( 'English', 'wpef7' ),
		'et' => __( 'Estonian', 'wpef7' ),
		'fi' => __( 'Finnish', 'wpef7' ),
		'fr_FR' => __( 'French', 'wpef7' ),
		'gl_ES' => __( 'Galician', 'wpef7' ),
		'ka_GE' => __( 'Georgian', 'wpef7' ),
		'de_DE' => __( 'German', 'wpef7' ),
		'el' => __( 'Greek', 'wpef7' ),
		'he_IL' => __( 'Hebrew', 'wpef7' ),
		'hi_IN' => __( 'Hindi', 'wpef7' ),
		'hu_HU' => __( 'Hungarian', 'wpef7' ),
		'id_ID' => __( 'Indonesian', 'wpef7' ),
		'it_IT' => __( 'Italian', 'wpef7' ),
		'ja' => __( 'Japanese', 'wpef7' ),
		'ko_KR' => __( 'Korean', 'wpef7' ),
		'lv' => __( 'Latvian', 'wpef7' ),
		'lt_LT' => __( 'Lithuanian', 'wpef7' ),
		'ml_IN' => __( 'Malayalam', 'wpef7' ),
		'nb_NO' => __( 'Norwegian', 'wpef7' ),
		'fa_IR' => __( 'Persian', 'wpef7' ),
		'pl_PL' => __( 'Polish', 'wpef7' ),
		'pt_PT' => __( 'Portuguese', 'wpef7' ),
		'ru_RU' => __( 'Russian', 'wpef7' ),
		'ro_RO' => __( 'Romanian', 'wpef7' ),
		'sr_RS' => __( 'Serbian', 'wpef7' ),
		'sk' => __( 'Slovak', 'wpef7' ),
		'sl_SI' => __( 'Slovene', 'wpef7' ),
		'es_ES' => __( 'Spanish', 'wpef7' ),
		'sv_SE' => __( 'Swedish', 'wpef7' ),
		'th' => __( 'Thai', 'wpef7' ),
		'tr_TR' => __( 'Turkish', 'wpef7' ),
		'uk' => __( 'Ukrainian', 'wpef7' ),
		'vi' => __( 'Vietnamese', 'wpef7' )
	);

	return $l10n;
}

?>