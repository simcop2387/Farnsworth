jQuery(document).ready(function() {
	try {
		jQuery.extend(jQuery.tgPanes, _wpef7.tagGenerators);
		jQuery('#taggenerator').tagGenerator(_wpef7L10n.generateTag,
			{ dropdownIconUrl: _wpef7.pluginUrl + '/images/dropdown.gif' });

		jQuery('input#wpef7-title:enabled').css({
			cursor: 'pointer'
		});

		jQuery('input#wpef7-title').mouseover(function() {
			jQuery(this).not('.focus').css({
				'background-color': '#ffffdd'
			});
		});

		jQuery('input#wpef7-title').mouseout(function() {
			jQuery(this).css({
				'background-color': '#fff'
			});
		});

		jQuery('input#wpef7-title').focus(function() {
			jQuery(this).addClass('focus');
			jQuery(this).css({
				cursor: 'text',
				color: '#333',
				border: '1px solid #777',
				font: 'normal 13px Verdana, Arial, Helvetica, sans-serif',
				'background-color': '#fff'
			});
		});

		jQuery('input#wpef7-title').blur(function() {
			jQuery(this).removeClass('focus');
			jQuery(this).css({
				cursor: 'pointer',
				color: '#555',
				border: 'none',
				font: 'bold 20px serif',
				'background-color': '#fff'
			});
		});

		jQuery('input#wpef7-title').change(function() {
			updateTag();
		});

		updateTag();

		if (jQuery.support.objectAll) {
			if (! jQuery('#wpef7-mail-2-active').is(':checked'))
				jQuery('#mail-2-fields').hide();

			jQuery('#wpef7-mail-2-active').click(function() {
				if (jQuery('#mail-2-fields').is(':hidden')
				&& jQuery('#wpef7-mail-2-active').is(':checked')) {
					jQuery('#mail-2-fields').slideDown('fast');
				} else if (jQuery('#mail-2-fields').is(':visible')
				&& jQuery('#wpef7-mail-2-active').not(':checked')) {
					jQuery('#mail-2-fields').slideUp('fast');
				}
			});
		}

		jQuery('#message-fields-toggle-switch').text(_wpef7L10n.show);
		jQuery('#message-fields').hide();

		jQuery('#message-fields-toggle-switch').click(function() {
			if (jQuery('#message-fields').is(':hidden')) {
				jQuery('#message-fields').slideDown('fast');
				jQuery('#message-fields-toggle-switch').text(_wpef7L10n.hide);
			} else {
				jQuery('#message-fields').hide('fast');
				jQuery('#message-fields-toggle-switch').text(_wpef7L10n.show);
			}
		});

		if ('' == jQuery.trim(jQuery('#wpef7-additional-settings').text())) {
			jQuery('#additional-settings-fields-toggle-switch').text(_wpef7L10n.show);
			jQuery('#additional-settings-fields').hide();
		} else {
			jQuery('#additional-settings-fields-toggle-switch').text(_wpef7L10n.hide);
			jQuery('#additional-settings-fields').show();
		}

		jQuery('#additional-settings-fields-toggle-switch').click(function() {
			if (jQuery('#additional-settings-fields').is(':hidden')) {
				jQuery('#additional-settings-fields').slideDown('fast');
				jQuery('#additional-settings-fields-toggle-switch').text(_wpef7L10n.hide);
			} else {
				jQuery('#additional-settings-fields').hide('fast');
				jQuery('#additional-settings-fields-toggle-switch').text(_wpef7L10n.show);
			}
		});

	} catch (e) {
	}
});

function updateTag() {
	var title = jQuery('input#wpef7-title').val();

	if (title)
		title = title.replace(/["'\[\]]/g, '');

	jQuery('input#wpef7-title').val(title);
	var current = jQuery('input#wpef7-id').val();
	var tag = '[eval-form ' + current + ' "' + title + '"]';

	jQuery('input#eval-form-anchor-text').val(tag);
}
