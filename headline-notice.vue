<template>
	<div
		v-if="isShown"
		class="headline-notice"
		:class="noticeClass"
		ref="headlineNotice"
	>
		<div class="headline-notice__wrap centerwrap lg-centerwrap">
			<div
				class="headline-notice__text"
				v-html="noticeText"
			/>
			<span
				v-if="notice.btnTitle"
				class="kw-button kw-button--white kw-button--size-40 kw-button--width-full-mobile"
				:class="btnClass"
				@click="onClick"
				ref="headlineNoticeButton"
			>
				{{notice.btnTitle}}
			</span>
		</div>
	</div>
</template>
<script>
	export default {
		data() {
			return {
				isShown: false,
				notice: null,
				buttonEnabled: true,
			};
		},

		computed: {
			noticeClass() {
				let classes = [];
				if (this.notice.btnClass) {
					classes.push(this.notice.btnClass);
				}

				if (this.notice.state) {
					classes.push('headline-notice--' + this.notice.state);
				}

				return classes;
			},

			btnClass() {
				let classes = [];
				if (this.notice.btnClass) {
					classes.push(this.notice.btnClass);
				}

				if (!this.buttonEnabled) {
					classes.push('disabled');
				}

				return classes;
			},

			noticeText() {
				let text = _.escape(this.notice.text);
				return '<p>' + text + '</p>';
			},
		},

		created() {
			window.bus.$on('headline-notice-open', (props) => {
				this.notice = _.assignIn({
					state: null,
					text: '',
					btnTitle: null,
					onShow: null,
				}, props);

				this.isShown = true;
				this.$nextTick(() => {
					this.$refs.headlineNotice.scrollIntoView({ behavior: 'smooth' });
				});
			});
		},

		methods: {
			/**
			 * Нажатие кнопки
			 */
			onClick() {
				if (this.buttonEnabled) {
					this.notice.onClick();
				}
			},
		},
	};
</script>
