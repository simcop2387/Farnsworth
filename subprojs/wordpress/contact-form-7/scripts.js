jQuery(document).ready(function() {
	try {
		jQuery('div.wpef7 > form').ajaxForm({
			beforeSubmit: wpef7BeforeSubmit,
			dataType: 'json',
			success: wpef7ProcessJson
		});
	} catch (e) {
	}

	try {
		jQuery('div.wpef7 > form').each(function(i, n) {
			wpef7ToggleSubmit(jQuery(n));
		});
	} catch (e) {
	}

	try {
		if (_wpef7.cached) {
			jQuery('div.wpef7 > form').each(function(i, n) {
				wpef7OnloadRefill(n);
			});
		}
	} catch (e) {
	}
});

// Exclusive checkbox
function wpef7ExclusiveCheckbox(elem) {
	jQuery(elem.form).find('input:checkbox[name="' + elem.name + '"]').not(elem).removeAttr('checked');
}

// Toggle submit button
function wpef7ToggleSubmit(form) {
	var submit = jQuery(form).find('input:submit');
	if (! submit.length) return;

	var acceptances = jQuery(form).find('input:checkbox.wpef7-acceptance');
	if (! acceptances.length) return;

	submit.removeAttr('disabled');
	acceptances.each(function(i, n) {
		n = jQuery(n);
		if (n.hasClass('wpef7-invert') && n.is(':checked') || ! n.hasClass('wpef7-invert') && ! n.is(':checked'))
		submit.attr('disabled', 'disabled');
	});
}

function wpef7BeforeSubmit(formData, jqForm, options) {
	wpef7ClearResponseOutput();
	jQuery('img.ajax-loader', jqForm[0]).css({ visibility: 'visible' });

	formData.push({name: '_wpef7_is_ajax_call', value: 1});
	jQuery(jqForm[0]).append('<input type="hidden" name="_wpef7_is_ajax_call" value="1" />');

	return true;
}

function wpef7NotValidTip(into, message) {
	jQuery(into).append('<span class="wpef7-not-valid-tip">' + message + '</span>');
	jQuery('span.wpef7-not-valid-tip').mouseover(function() {
		jQuery(this).fadeOut('fast');
	});
	jQuery(into).find(':input').mouseover(function() {
		jQuery(into).find('.wpef7-not-valid-tip').not(':hidden').fadeOut('fast');
	});
	jQuery(into).find(':input').focus(function() {
		jQuery(into).find('.wpef7-not-valid-tip').not(':hidden').fadeOut('fast');
	});
}

function wpef7OnloadRefill(form) {
	var url = jQuery(form).attr('action');
	if (0 < url.indexOf('#'))
		url = url.substr(0, url.indexOf('#'));

	var id = jQuery(form).find('input[name="_wpef7"]').val();
	var unitTag = jQuery(form).find('input[name="_wpef7_unit_tag"]').val();

	jQuery.getJSON(url,
		{ _wpef7_is_ajax_call: 1, _wpef7: id },
		function(data) {
			if (data && data.captcha) {
				wpef7RefillCaptcha('#' + unitTag, data.captcha);
			}
			if (data && data.quiz) {
				wpef7RefillQuiz('#' + unitTag, data.quiz);
			}
		}
	);
}

function wpef7ProcessJson(data) {
	var wpef7ResponseOutput = jQuery(data.into).find('div.wpef7-response-output');
	wpef7ClearResponseOutput();

	if (data.invalids) {
		jQuery.each(data.invalids, function(i, n) {
			wpef7NotValidTip(jQuery(data.into).find(n.into), n.message);
		});
		wpef7ResponseOutput.addClass('wpef7-validation-errors');
	}

	if (data.captcha) {
		wpef7RefillCaptcha(data.into, data.captcha);
	}

	if (data.quiz) {
		wpef7RefillQuiz(data.into, data.quiz);
	}

	if (1 == data.spam) {
		wpef7ResponseOutput.addClass('wpef7-spam-blocked');
	}

	if (1 == data.mailSent) {
		jQuery(data.into).find('form').resetForm().clearForm();
		wpef7ResponseOutput.addClass('wpef7-mail-sent-ok');

		if (data.onSentOk)
			jQuery.each(data.onSentOk, function(i, n) { eval(n) });
	} else {
		wpef7ResponseOutput.addClass('wpef7-mail-sent-ng');
	}

	if (data.onSubmit)
		jQuery.each(data.onSubmit, function(i, n) { eval(n) });

	wpef7ResponseOutput.append(data.message).slideDown('fast');
}

function wpef7RefillCaptcha(form, captcha) {
	jQuery.each(captcha, function(i, n) {
		jQuery(form).find(':input[name="' + i + '"]').clearFields();
		jQuery(form).find('img.wpef7-captcha-' + i).attr('src', n);
		var match = /([0-9]+)\.(png|gif|jpeg)$/.exec(n);
		jQuery(form).find('input:hidden[name="_wpef7_captcha_challenge_' + i + '"]').attr('value', match[1]);
	});
}

function wpef7RefillQuiz(form, quiz) {
	jQuery.each(quiz, function(i, n) {
		jQuery(form).find(':input[name="' + i + '"]').clearFields();
		jQuery(form).find(':input[name="' + i + '"]').siblings('span.wpef7-quiz-label').text(n[0]);
		jQuery(form).find('input:hidden[name="_wpef7_quiz_answer_' + i + '"]').attr('value', n[1]);
	});
}

function wpef7ClearResponseOutput() {
	jQuery('div.wpef7-response-output').hide().empty().removeClass('wpef7-mail-sent-ok wpef7-mail-sent-ng wpef7-validation-errors wpef7-spam-blocked');
	jQuery('span.wpef7-not-valid-tip').remove();
	jQuery('img.ajax-loader').css({ visibility: 'hidden' });
}