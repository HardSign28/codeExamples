$(document).ready(function () {

	window.bus.$on('settingsMailLost', () => {
		window.app.$refs.headlineNoticeSettings.buttonEnabled = false;
		$.post('/settings/update_email_reset', {
			email: $('#email').val(),
		}, (data) => {
			if (data.success) {
				window.location.href = '/inbox/support';
			} else {
				window.app.$refs.headlineNoticeSettings.buttonEnabled = true;
			}
		}, 'json');
	});

	// Проверка на плохие почтовые сервисы
	$('#settings_form #email').change(function () {
		let $emailEntryError = $('#settings_form .js-email-entry-error');
		$emailEntryError.text('');
		let badMailHost = checkBadEmailDomains($(this).val());
		if (badMailHost !== false && badMailHost.length > 1) {
			$emailEntryError.text(l('srcJsSettingsSettingsPageJs5', 'legacy-translations', [upstring(badMailHost)]));
		}
	});

	// Показать модалку с подтверждением для кошелька
	if (window.needConfirmPurseBlock) {
		window.showConfirmPurseBlock(window.confirmPurseBlockText);
	}

	// Показать модалку Добавить номер
	$('.js-settings-phone-add').on('click', function (e) {
		e.preventDefault();
		window.bus.$emit('phone-setting-modal-open', {
			type: 'from-settings',
			phone: $('.js-settings-phone input').val(),
		});
	});

	// Показать модалку Удалить номер
	$('.js-settings-phone-delete').click(function (e) {
		e.preventDefault();
		phoneVerifiedOpenModal(null, 'phone-delete');
	});

	// Выслать Email подтверждения смены номера еще раз
	$('.js-settings-mail-resend').click(function (e) {
		e.preventDefault();
		$.post('/settings_resend_email_phone_confirmation', function (data) {
			var $message = $('.js-settings-phone-block .settings-phone-block-error');
			if (data.success) {
				$message.removeClass('color-red').addClass('color-green');
				$message.html(l('srcJsSettingsSettingsPageJs1', 'legacy-translations'));
			} else {
				$message.removeClass('color-green').addClass('color-red');
				$message.html(data.error);
			}
		});
	});

	updateHeaderColor();
});

/**
 * Изменение цвета шапки
 */
function updateHeaderColor() {
	window.initThemeColor();
	window.initMobileHeader();
}

$(window).load(function () {
	$('#wm_purse').prop('placeholder', l('enterZWalletPlaceholder', 'pages/settings/finances'));

	$('#qiwi_purse').prop('placeholder', l('srcJsSettingsSettingsPageJs3', 'legacy-translations'));

	$('#card_purse').prop('placeholder', l('enterCardNumber', 'pages/settings/finances'));
});
