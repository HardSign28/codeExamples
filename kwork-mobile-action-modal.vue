<template>
	<k-modal
		v-model="isModalOpened"
		modal-class="kwork-mobile-action-modal"
		backdrop="dark"
		:title="l('kworkMobileActionModalTitle', '/pages/manage-kworks/kwork-mobile-action-modal')"
		design="small"
	>
		<div class="kwork-mobile-action-modal__menu">
			<div class="kwork-mobile-action-modal__menu-item" @click="editKwork">
				<svg class="menu-item-icon" width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path d="M3.75 13.646v2.604h2.604l7.684-7.684-2.604-2.604-7.684 7.684zm12.295-7.087a.696.696 0 0 0 0-.983l-1.621-1.621a.696.696 0 0 0-.983 0l-1.27 1.27 2.603 2.605 1.271-1.271z" fill="#A5A5A5"/>
				</svg>
				{{ l('kworkMobileActionModalButtonEdit', '/pages/manage-kworks/kwork-mobile-action-modal') }}
			</div>
			<template v-if="kwork.status !== 'draft'">
				<div v-if="!kwork.isOnModeration" class="kwork-mobile-action-modal__menu-item" @click="duplicateKwork">
					<svg class="menu-item-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"><path fill-rule="evenodd" d="M11 3.6H6a.4.4 0 0 0-.4.4v7a.4.4 0 0 0 .4.4V13a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h5a2 2 0 0 1 2 2v1h-1.6V4a.4.4 0 0 0-.4-.4zm-2 4h5a.4.4 0 0 1 .4.4v7a.4.4 0 0 1-.4.4H9a.4.4 0 0 1-.4-.4V8a.4.4 0 0 1 .4-.4zM7 8a2 2 0 0 1 2-2h5a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2V8z" fill="#a5a5a5"/></svg>
					{{ l('duplicateKwork', 'pages/manage-kworks/kwork-mobile-action-modal') }}
				</div>
				<div v-if="kwork.status === 'paused'" class="kwork-mobile-action-modal__menu-item" @click="activateKwork">
					<svg class="menu-item-icon" width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
						<path fill-rule="evenodd" clip-rule="evenodd" d="M7.37 4.896a1 1 0 0 0-1.495.87v8.46a1 1 0 0 0 1.486.873l7.52-4.183a1 1 0 0 0 .008-1.743L7.37 4.896z" fill="#A5A5A5"/>
					</svg>
					{{ l('kworkMobileActionModalButtonActivate', '/pages/manage-kworks/kwork-mobile-action-modal') }}
				</div>
				<div v-else class="kwork-mobile-action-modal__menu-item" @click="suspendKwork">
					<svg class="menu-item-icon" width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
						<path fill-rule="evenodd" clip-rule="evenodd" d="M4.75 4.75v10.5h3V4.75h-3zM12.25 4.75v10.5h3V4.75h-3z" fill="#A5A5A5"/>
					</svg>
					{{ l('kworkMobileActionModalButtonPause', '/pages/manage-kworks/kwork-mobile-action-modal') }}
				</div>
			</template>
			<div class="kwork-mobile-action-modal__menu-item" @click="deleteKwork">
				<svg class="menu-item-icon" width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path d="M12 5V3.667H8V5H4v1.333h12V5h-4zM5.333 7v8c0 .734.598 1.333 1.334 1.333h6.666c.736 0 1.334-.599 1.334-1.333V7H5.333zm4 6.667H8v-4h1.333v4zm2.667 0h-1.333v-4H12v4z" fill="#A5A5A5"/>
				</svg>
				{{ l('kworkMobileActionModalButtonDelete', '/pages/manage-kworks/kwork-mobile-action-modal') }}
			</div>
		</div>
	</k-modal>
</template>

<script>
	import CdnMixin from 'mixins/CdnMixin.js'; // Приведение относительных ссылок к абсолютным (CDN)
	import KModalMixin from 'src/components/k-modal/KModalMixin.js'; // mixin для модального окна k-modal
	import LocalizationMixin from 'mixins/LocalizationMixin.js'; // Локализация

	export default {
		mixins: [
			CdnMixin,
			KModalMixin,
			LocalizationMixin,
		],

		data() {
			return {
				kwork: {},
			};
		},

		created() {
			window.bus.$on('kwork-mobile-actions-modal-open', (props) => {
				this.kwork = _.assignIn({
					id: 0,
					status: null,
					isOnModeration: false,
				}, props);
				this.openModal();
			});
		},

		methods: {
			/**
			 * Приостановка кворка
			 */
			suspendKwork() {
				let suspendButton = document.querySelector("[data-suspend-kwork-id='" + this.kwork.id + "']");
				suspendButton.click();
				this.closeModal();
			},

			/**
			 * Редактирование кворка
			 */
			editKwork() {
				let editButton = document.querySelector("[data-edit-kwork-id='" + this.kwork.id + "']");
				editButton.click();
				this.closeModal();
			},

			/**
			 * Активация кворка
			 */
			activateKwork() {
				let activateButton = document.querySelector("[data-activate-kwork-id='" + this.kwork.id + "']");
				activateButton.click();
				this.closeModal();
			},

			/**
			 * Активация кворка
			 */
			deleteKwork() {
				let deleteButton = document.querySelector("[data-delete-kwork-id='" + this.kwork.id + "']");
				deleteButton.click();
				this.closeModal();
			},

			/**
			 * Дублирование кворка
			 */
			duplicateKwork() {
				let duplicateButton = document.querySelector("[data-duplicate-kwork-id='" + this.kwork.id + "']");
				duplicateButton.click();
				this.closeModal();
			},
		},
	};
</script>
