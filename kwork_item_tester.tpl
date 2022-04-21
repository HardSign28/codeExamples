{strip}
	{$post.photo = WebpManager::getImageByContext($post.photo, $post.is_resizing)}
	{$isDraft = $post.active == KworkManager::STATUS_DRAFT}
	{$isPaused = $post.active == KworkManager::STATUS_PAUSE}
	{$isRejected = $post.active == KworkManager::STATUS_REJECTED}
	{$isModerated = $post.active == KworkManager::STATUS_MODERATION}
	{* 16698 Новая карточка кворка в Мои кворки для тестеров *}
	{$hasStats = $post.statistics.done_orders_percent.done_orders_percent || $post.statistics.review_rating.level || ($post.rotation_conversion && $post.statistics.conversion.level && $post.done_order_count >= UserStatisticManager::USER_PERCENTS_ORDER_DONE_THRESHOLD)}
	{if !$isDraft && !$isRejected}
		{if $post.feat == KworkManager::FEAT_ACTIVE}
			{assign var="datakworkStatus" value="active"}
		{else}
			{assign var="datakworkStatus" value="paused"}
		{/if}
	{else}
		{assign var="datakworkStatus" value="draft"}
	{/if}

	{* Плашка Черная пятница *}
		{if $posts[i].is_black_friday}
			{include file="promo/blackfriday/kwork-promo-badge.tpl" left=true}
		{/if}
	{* /Плашка Черная пятница *}
	<div class="relative card js-kwork-card new-manage-kworks-item sm-margin-reset kwork-wrap js-kwork-analytics js-kwork-analytics-{$post.PID}" data-kwork-id="{$post.PID}" data-kwork-status="{$datakworkStatus}" {if $isModerated}data-kwork-moderation="true"{/if}>
		<div class="d-flex flex-nowrap newfoxwrapper new-manage-kworks-item__inner">
			<div class="newfoximg responsivefoximages new-manage-kworks-item__left-part{if $post.first_portfolio_id} kwork-card-portfolio-wrapper{/if}">
				<a href="{if $isDraft}{$baseurl}/new?draft_id={$post.PID}{if $post.lang == Translations::EN_LANG}&lang={Translations::EN_LANG}{/if}{else}{$baseurl}{$post.url}{/if}" class="ispinner-container {if $isDraft}js-create-kwork-btn pointer-en{/if}" {if $isDraft}data-draft-id="{$post.PID}"{/if}>
					{include file="_blocks/thumbnail_img_load.tpl" spinnerMode="lite"}
					{if $post.photo}
						{if $post.is_resizing == 0}
							{assign var="imageSize" value="t2"}
						{else}
							{assign var="imageSize" value="t0"}
						{/if}
						<img src="{$purl}/{$imageSize}/{$post.photo}" {photoSrcset($imageSize, $post.photo)} alt="" class="db" onload="window.Spinner.removeISpinner(event)">
					{else}
						<img src="{"/collage/640x357/collage_default_category.jpg"|cdnImageUrl}" alt="" class="db centered-image" onload="window.Spinner.removeISpinner(event)">
					{/if}
				</a>
				{if $post.first_portfolio_id}
					{include file="_blocks/kwork/kwork_card_portfolio.tpl" isSmallIcon=true portfolioId=$post.first_portfolio_id}
				{/if}
				{* Плашка процент портфолио *}
				{if $post.showPortfolioPercent}
					{include file="manage_kworks/portfolio-level-colored.tpl" fillPercent=$post.portfolio_fill_percent['percent']}
				{/if}
			</div>
			<div class="newfoxdetails relative new-manage-kworks-item__right-part {if !$isDraft && $post.is_need_update_price || $post.is_need_update_packages || $post.is_need_update_package_prices || $post.is_need_update || $post.is_need_update_volume || $post.is_need_update_translates || $post.is_need_add_portfolio || $post.is_need_update_links || $post.outsider_reason_hint }new-manage-kworks-item-left-bottom-line{/if}">
				<div class="new-manage-kworks-item__top-part">
					<h3 class="new-manage-kworks-item__title">
						<a href="{if $isDraft}{$baseurl}/new?draft_id={$post.PID}{if $post.lang == Translations::EN_LANG}&lang={Translations::EN_LANG}{/if}{else}{$baseurl}{$post.url}{/if}" {if strlen($post.gtitle) > 85}title="{$post.gtitle|stripslashes|upstring}"{/if} {if $isDraft}class="js-create-kwork-btn pointer-en" data-draft-id="{$post.PID}"{/if}><span class="dib">{$post.gtitle|ucfirst|stripslashes|mb_truncate:85:"...":'UTF-8'}</span></a>
					</h3>
					<div class="new-manage-kworks-item__top-right-part">
						{* Мобильное меню *}
						<div class="m-visible js-kwork-mobile-actions-modal-open">
							<svg width="24" height="24" fill="none" xmlns="http://www.w3.org/2000/svg">
								<path fill-rule="evenodd" clip-rule="evenodd" d="M14 5a2 2 0 1 0-4 0 2 2 0 0 0 4 0zm-2 5a2 2 0 1 1 0 4 2 2 0 0 1 0-4zm0 7a2 2 0 1 1 0 4 2 2 0 0 1 0-4z" fill="#A5A5A5"/>
							</svg>
						</div>
						{* /Мобильное меню *}
						{* Кнопки редактировать/удалить *}
						<div class="manage-kworks-actions m-hidden">
							{if !$isSuspend}
								<div class="manage-kworks-actions__item">
								<span
									class="manage-kworks-actions__link {if $isDraft}js-delete-draft-button{else}js-delete-button{/if} tooltipster"
									data-has-portfolio="{intval($post.has_portfolio)}"
									data-tooltip-text="{"removeKwork"|l:"pages/manage-kworks/kwork-item"}"
									data-tooltip-theme="light"
									data-tooltip-mhidden="true"
									data-tooltip-interactive="false"
									data-delete-kwork-id="{$post.PID}"
									data-has-offers="{intval($post.active == KworkManager::FEAT_ACTIVE && $post.has_offers)}"
								>
									<svg class="icon-bin" width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
										<path d="M12 5V3.667H8V5H4v1.333h12V5h-4zM5.333 7v8c0 .734.598 1.333 1.334 1.333h6.666c.736 0 1.334-.599 1.334-1.333V7H5.333zm4 6.667H8v-4h1.333v4zm2.667 0h-1.333v-4H12v4z" fill="#A5A5A5"/>
									</svg>
								</span>
								</div>
								{if !$isDraft && !$isRejected}
									<div class="manage-kworks-actions__item">
										{if $post.feat == KworkManager::FEAT_ACTIVE}
											<span
												class="manage-kworks-actions__link js-suspend-button tooltipster"
												data-tooltip-text="{"tooltipActionSuspend"|l:"pages/manage-kworks/kwork-item"}"
												data-tooltip-theme="light"
												data-tooltip-mhidden="true"
												data-tooltip-interactive="false"
												data-suspend-kwork-id="{$post.PID}"
												data-has-offers="{intval($post.has_offers)}"
											>
												<svg width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
													<path fill-rule="evenodd" clip-rule="evenodd" d="M4.75 4.75v10.5h3V4.75h-3zM12.25 4.75v10.5h3V4.75h-3z" fill="#A5A5A5"/>
												</svg>
											</span>
										{else}
											<span
												class="manage-kworks-actions__link js-activate-button tooltipster"
												data-tooltip-text="{"tooltipActionActive"|l:"pages/manage-kworks/kwork-item"}"
												data-tooltip-theme="light"
												data-tooltip-mhidden="true"
												data-tooltip-interactive="false"
												data-activate-kwork-id="{$post.PID}"
											>
												<svg class="menu-item-icon" width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
													<path fill-rule="evenodd" clip-rule="evenodd" d="M7.37 4.896a1 1 0 0 0-1.495.87v8.46a1 1 0 0 0 1.486.873l7.52-4.183a1 1 0 0 0 .008-1.743L7.37 4.896z" fill="#A5A5A5"/>
												</svg>
											</span>
										{/if}
									</div>
								{/if}
								{if !$isDraft && !$isRejected && !$isModerated && UserManager::isTester($actor->id)}
									<div class="manage-kworks-actions__item manage-kworks-actions__item--duplicate">
										<span
											class="manage-kworks-actions__link js-duplicate-button tooltipster"
											data-tooltip-text="{"duplicateKwork"|l:"pages/manage-kworks/kwork-item"}"
											data-tooltip-mhidden="true"
											data-tooltip-interactive="false"
											data-duplicate-kwork-id="{$post.PID}"
										>
											<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"><path fill-rule="evenodd" d="M11 3.6H6a.4.4 0 0 0-.4.4v7a.4.4 0 0 0 .4.4V13a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h5a2 2 0 0 1 2 2v1h-1.6V4a.4.4 0 0 0-.4-.4zm-2 4h5a.4.4 0 0 1 .4.4v7a.4.4 0 0 1-.4.4H9a.4.4 0 0 1-.4-.4V8a.4.4 0 0 1 .4-.4zM7 8a2 2 0 0 1 2-2h5a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2V8z" fill="#a5a5a5"/></svg>
										</span>
									</div>
								{/if}
								<div class="manage-kworks-actions__item">
									{if $isDraft}
										{$href = "{$baseurl}/new?draft_id={$post.PID}{if $post.lang == Translations::EN_LANG}&lang={Translations::EN_LANG}{/if}"}
									{else}
										{$href = "{$baseurl}/edit?id={$post.PID}"}
									{/if}
									<span
										class="manage-kworks-actions__link js-edit-button tooltipster {if $isDraft}js-create-kwork-btn pointer-en{/if}"
										data-tooltip-text="{"editKwork"|l:"pages/manage-kworks/kwork-item"}"
										data-tooltip-theme="light"
										data-tooltip-mhidden="true"
										data-tooltip-interactive="false"
										data-href="{$href}"
										data-has-offers="{intval($post.has_offers)}"
										data-edit-kwork-id="{$post.PID}"
										{if $isDraft}data-draft-id="{$post.PID}"{/if}
									>
										<svg class="menu-item-icon" width="20" height="20" fill="none" xmlns="http://www.w3.org/2000/svg">
											<path d="M3.75 13.646v2.604h2.604l7.684-7.684-2.604-2.604-7.684 7.684zm12.295-7.087a.696.696 0 0 0 0-.983l-1.621-1.621a.696.696 0 0 0-.983 0l-1.27 1.27 2.603 2.605 1.271-1.271z" fill="#A5A5A5"/>
										</svg>
									</span>
								</div>
							{/if}
						</div>
						{* /Кнопки редактировать/удалить *}
					</div>
				</div>
				<div class="new-manage-kworks-item__bottom-part d-flex justify-content-between align-items-end">
					{* Бейдж выбор кворк *}
					{if $post.done_order_count >= 8 && !$isDraft}
						<div class="d-flex justify-content-end align-items-center new-manage-kworks-item__rating">
							{if $post.top_badge}
								<span
									class="new-manage-kworks-item__rating-link js-popup-rating cur"
									data-responsibility="{if $post.statistics.done_orders_percent.done_orders}{($post.statistics.done_orders_percent.done_orders * 100 / $post.statistics.done_orders_percent.total)|zero}{else}0{/if}"
									data-reviews="{if $post.statistics.review_rating.user_percent.good}{$post.statistics.review_rating.user_percent.good|zero}{else}0{/if}"
									data-conversion="{if $post.statistics.conversion.user_percent.good}{$post.statistics.conversion.user_percent.good|zero}{else}0{/if}"
									data-requests="{100 - $post.warning_messages_ignored_percent|zero}"
								>
									{"howDoIGetKworkChoice"|l:"pages/manage-kworks/kwork-item"}
								</span>
							{else}
								<div class="kwork-badge-rating__wrap">
									{include file="_blocks/kwork/badge/kwork-badge-rating.tpl" tooltipRating="{"kworkChoiceTooltip"|l:"pages/manage-kworks/kwork-item"}"}
								</div>
							{/if}
						</div>
					{/if}
					{* /Бейдж выбор кворк *}
					{* ЦЕНА *}
					<div class="mt-4 new-manage-kworks-item__price-wrapper nowrap">
						{if $post.baseVolumePrice}
							{include file="utils/volume-price.tpl" baseVolumePrice=$post.baseVolumePrice baseVolume=$post.baseVolume baseVolumeShortName=$post.baseVolumeShortName lang=$post.lang}
						{/if}
						<div class="fw700 fs22 new-manage-kworks-item__price js-price-actual nowrap {if \PromoBlackFridayManager::isPromoActiveForWorker() && $post.is_black_friday}p-blackfriday-price-actual{/if}">
							{if $post.is_package || $post.hasVolume}
								<span class="fw600 mr5 f16">{'priceFrom'|l:"pages/manage-kworks/kwork-item"}</span>
							{/if}
							{include file="utils/currency.tpl" lang=$post.lang total=$post.workerPrice}
						</div>
						{if \PromoBlackFridayManager::isPromoActiveForWorker() && $post.is_black_friday}
							{$newPrice = $post.workerPrice - $post.discountAmount}
							<div class="js-price-discount p-blackfriday-price-discount nowrap {if !\PromoBlackFridayManager::isPromoActiveForPayer()}tooltipster{/if}"
								data-tooltip-text="Цена будет активна с 26 ноября"
								data-tooltip-theme="light">
									<span class="p-blackfriday-gradient">
										{if $post.is_package || $post.hasVolume}{'priceFrom'|l:"pages/manage-kworks/kwork-item"} {/if}
										{include file="utils/currency.tpl" lang=$post.lang total=$newPrice}
									</span>
							</div>
						{/if}
					</div>
					{* /ЦЕНА *}
					</div>
			</div>
			{* СТАТИСТИКА *}
			<div class="new-manage-kworks-item__stats m-hidden {if $isDraft}d-flex justify-content-center align-items-center{/if}">
				{if !$isDraft}
					<div class="new-manage-kworks-item__stats-rating">
						{if $hasStats}
							{* Ответственность *}
							<div class="new-manage-kworks-item__stats-rating-item">
								{* title *}
								<div>
									{'ratingReliability'|l:"pages/manage-kworks/kwork-item"}:
								</div>
								{* #title *}
								<div class="d-flex align-items-center">
									{* value *}
									{if $post.statistics.done_orders_percent.level}
										{include file="manage_kworks/kwork_item_rating_value.tpl" level=$post.statistics.done_orders_percent.level value=$post.statistics.done_orders_percent.user_percent.good}
									{else}
										<span class="fw600">{'noData'|l:"pages/manage-kworks/kwork-item"}</span>
									{/if}
									{* #value *}
									{* tooltip *}
									<div class="dib tooltip_circle tooltip_circle--gray-border-field tooltip_circle--size14 tooltip_circle--hover tooltipster ml5 js-kwork-analytics-tooltip"
										{if $post.statistics.done_orders_percent.level}
											data-tooltip-content="#done-orders-percent-{$post.PID}"
											data-tooltip-side="bottom"
											data-kwork-id="{$post.PID}"
											data-tooltip-width="auto"
											data-metric="{UserStatisticManager::METRIC_DONE_ORDERS_PERCENT}"
										{else}
											data-tooltip-text="{"doNotHaveEnoughDataForThisRating"|l:"pages/manage-kworks/kwork-item"}"
											data-tooltip-side="right"
											data-tooltip-interactive="true"
										{/if}
										data-tooltip-theme="light">
										{if $post.statistics.done_orders_percent.level}
											<div class="d-none">
												<div id="done-orders-percent-{$post.PID}" class="kwork-item-tooltip-content">
													{include file="manage_kworks/tooltip_done_orders_percent.tpl"}
												</div>
											</div>
										{/if}
										?
									</div>
									{* #tooltip *}
								</div>
							</div>
							{* #Ответственность *}
							{* Отзывы *}
							<div class="new-manage-kworks-item__stats-rating-item">
								{* title *}
								<div>
									{'ratingReviews'|l:"pages/manage-kworks/kwork-item"}:
								</div>
								{* #title *}
								<div class="d-flex align-items-center">
									{* value *}
									{if $post.statistics.review_rating.level}
										{include file="manage_kworks/kwork_item_rating_value.tpl" level=$post.statistics.review_rating.level value=$post.statistics.review_rating.user_percent.good}
									{else}
										<span class="fw600">{'noData'|l:"pages/manage-kworks/kwork-item"}</span>
									{/if}
									{* #value *}
									{* tooltip *}
									<div class="dib tooltip_circle tooltip_circle--gray-border-field tooltip_circle--size14 tooltip_circle--hover tooltipster ml5"
										{if $post.statistics.review_rating.level}
											data-tooltip-content="#review-rating-{$post.PID}"
											data-tooltip-side="bottom"
											data-kwork-id="{$post.PID}"
											data-tooltip-width="auto"
											data-metric="{UserStatisticManager::METRIC_REVIEW_RATING}"
										{else}
											data-tooltip-text="{"doNotHaveEnoughDataForThisRating"|l:"pages/manage-kworks/kwork-item"}"
											data-tooltip-side="right"
											data-tooltip-interactive="true"
										{/if}
										 data-tooltip-theme="light">
										{if $post.statistics.review_rating.level}
											<div class="d-none">
												<div id="review-rating-{$post.PID}" class="kwork-item-tooltip-content">
													{include file="manage_kworks/tooltip_review_rating.tpl"}
												</div>
											</div>
										{/if}
										?
									</div>
									{* #tooltip *}
								</div>
							</div>
							{* #Отзывы *}
							{* Конверсия *}
							<div class="new-manage-kworks-item__stats-rating-item">
								{* title *}
								<div>
									{'ratingConversion'|l:"pages/manage-kworks/kwork-item"}:
								</div>
								{* #title *}
								<div class="d-flex align-items-center">
									{* value *}
									{if $post.statistics.conversion.level}
										{include file="manage_kworks/kwork_item_rating_value.tpl" level=$post.statistics.conversion.level value=$post.statistics.conversion.user_percent.good}
									{else}
										<span class="fw600">{'noData'|l:"pages/manage-kworks/kwork-item"}</span>
									{/if}
									{* #value *}
									{* tooltip *}
									<div class="dib tooltip_circle tooltip_circle--gray-border-field tooltip_circle--size14 tooltip_circle--hover tooltipster ml5"
										{if $post.statistics.conversion.level}
											data-tooltip-content="#conversion-{$post.PID}"
											data-tooltip-side="bottom"
											data-kwork-id="{$post.PID}"
											data-tooltip-width="auto"
											data-metric="{UserStatisticManager::METRIC_REVIEW_RATING}"
										{else}
											data-tooltip-text="{"doNotHaveEnoughDataForThisRating"|l:"pages/manage-kworks/kwork-item"}"
											data-tooltip-side="right"
											data-tooltip-interactive="true"
										{/if}
										data-tooltip-theme="light">
										{if $post.statistics.conversion.level}
											<div class="d-none">
												<div id="conversion-{$post.PID}" class="kwork-item-tooltip-content">
													{include file="manage_kworks/tooltip_conversion.tpl"}
												</div>
											</div>
										{/if}
										?
									</div>
									{* #tooltip *}
								</div>
							</div>
							{* #Конверсия *}
						{else}
							<div class="new-manage-kworks-item__stats-rating-dummy">
								{"kworkRatingTextDummy"|l:"pages/manage-kworks/kwork-item"}
							</div>
						{/if}
					</div>
					<div class="new-manage-kworks-item__metrics">
						<div class="new-manage-kworks-item__metrics-item">
							<img class="kwork-icon icon-eye" src="{"/icons/icon-eye-16.svg"|cdnImageUrl}" width="17" height="16" alt="">
							{if $post.viewcount > 0}
								<span>{$post.viewcount|stripslashes|zero}</span>
							{else}
								<span>0</span>
							{/if}
						</div>
						<div class="new-manage-kworks-item__metrics-item">
							<img class="kwork-icon icon-cart" src="{"/icons/icon-cart-16.svg"|cdnImageUrl}" width="16" height="16" alt="">
							{if $post.done_order_count > 0}
								<span>{$post.done_order_count|zero}</span>
							{else}
								<span>0</span>
							{/if}
						</div>
						<div class="new-manage-kworks-item__metrics-item">
							<img class="kwork-icon icon-earn" src="{"/icons/icon-earn-14.svg"|cdnImageUrl}" width="14" height="14" alt="">
							{if $post.rev > 0}
								<span>{include file="utils/currency.tpl" lang=$actor->lang total=$post.rev}</span>
							{else}
								<span>0</span>
							{/if}
						</div>
						<span class="tooltip_circle tooltip_circle--gray-border-field tooltip_circle--size14 tooltip_circle--hover tooltipster ml9"
							data-tooltip-side="bottom"
							data-tooltip-text="{"activityInfoTooltip"|l:"pages/manage-kworks/kwork-item"}"
							data-tooltip-theme="light">
							?
						</span>
					</div>
				{else}
					<div class="new-manage-kworks-item__draft-stamp">
						{"kworkDraftStamp"|l:"pages/manage-kworks/kwork-item"}
					</div>
				{/if}
			</div>
			{* /СТАТИСТИКА *}
		</div>
		{* Место для уведомлений *}
		<div class="new-manage-kworks-item__notify-wrap">
			{if !$isDraft}
				<div class="new-manage-kworks-item__notify m-visible">
					<div v-b-toggle="'collapse-stats-{$post.PID}'" class="new-manage-kworks-item__notify-title">
						<img class="kwork-icon icon-kwork-draft" src="{"/icons/icon-stats.svg"|cdnImageUrl}" width="20" height="20" alt="">
						<span class="fw600">{"kworkStats"|l:"pages/manage-kworks/kwork-item"}</span>
					</div>
					<b-collapse id="collapse-stats-{$post.PID}" class="new-manage-kworks-item__notify-body">
						{* Мобильная статистика *}
						<div class="d-flex flex-column">
							<div class="new-manage-kworks-item__stats-rating">
								{if $hasStats}
									{* Ответственность *}
									<div class="new-manage-kworks-item__stats-rating-item">
										{* title *}
										<div>
											{'ratingReliability'|l:"pages/manage-kworks/kwork-item"}:
										</div>
										{* #title *}
										<div class="d-flex align-items-center">
											{* value *}
											{if $post.statistics.done_orders_percent.level}
												{include file="manage_kworks/kwork_item_rating_value.tpl" level=$post.statistics.done_orders_percent.level value=$post.statistics.done_orders_percent.user_percent.good}
											{else}
												<span class="fw600">{'noData'|l:"pages/manage-kworks/kwork-item"}</span>
											{/if}
											{* #value *}
											{* tooltip *}
											<div class="dib tooltip_circle tooltip_circle--gray-border-field tooltip_circle--size14 tooltip_circle--hover tooltipster ml5 js-kwork-analytics-tooltip"
												{if $post.statistics.done_orders_percent.level}
													data-tooltip-content="#done-orders-percent-{$post.PID}"
													data-tooltip-side="bottom"
													data-kwork-id="{$post.PID}"
													data-tooltip-width="auto"
													data-metric="{UserStatisticManager::METRIC_DONE_ORDERS_PERCENT}"
												{else}
													data-tooltip-text="{"doNotHaveEnoughDataForThisRating"|l:"pages/manage-kworks/kwork-item"}"
													data-tooltip-side="right"
													data-tooltip-interactive="true"
												{/if}
												data-tooltip-theme="light">
												{if $post.statistics.done_orders_percent.level}
													<div class="d-none">
														<div id="done-orders-percent-{$post.PID}" class="kwork-item-tooltip-content">
															{include file="manage_kworks/tooltip_done_orders_percent.tpl"}
														</div>
													</div>
												{/if}
												?
											</div>
											{* #tooltip *}
										</div>
									</div>
									{* #Ответственность *}
									{* Отзывы *}
									<div class="new-manage-kworks-item__stats-rating-item">
										{* title *}
										<div>
											{'ratingReviews'|l:"pages/manage-kworks/kwork-item"}:
										</div>
										{* #title *}
										<div class="d-flex align-items-center">
											{* value *}
											{if $post.statistics.review_rating.level}
												{include file="manage_kworks/kwork_item_rating_value.tpl" level=$post.statistics.review_rating.level value=$post.statistics.review_rating.user_percent.good}
											{else}
												<span class="fw600">{'noData'|l:"pages/manage-kworks/kwork-item"}</span>
											{/if}
											{* #value *}
											{* tooltip *}
											<div class="dib tooltip_circle tooltip_circle--gray-border-field tooltip_circle--size14 tooltip_circle--hover tooltipster ml5"
												{if $post.statistics.review_rating.level}
													data-tooltip-content="#review-rating-{$post.PID}"
													data-tooltip-side="bottom"
													data-kwork-id="{$post.PID}"
													data-tooltip-width="auto"
													data-metric="{UserStatisticManager::METRIC_REVIEW_RATING}"
												{else}
													data-tooltip-text="{"doNotHaveEnoughDataForThisRating"|l:"pages/manage-kworks/kwork-item"}"
													data-tooltip-side="right"
													data-tooltip-interactive="true"
												{/if}
												data-tooltip-theme="light">
												{if $post.statistics.review_rating.level}
													<div class="d-none">
														<div id="review-rating-{$post.PID}" class="kwork-item-tooltip-content">
															{include file="manage_kworks/tooltip_review_rating.tpl"}
														</div>
													</div>
												{/if}
												?
											</div>
											{* #tooltip *}
										</div>
									</div>
									{* #Отзывы *}
									{* Конверсия *}
									<div class="new-manage-kworks-item__stats-rating-item">
										{* title *}
										<div>
											{'ratingConversion'|l:"pages/manage-kworks/kwork-item"}:
										</div>
										{* #title *}
										<div class="d-flex align-items-center">
											{* value *}
											{if $post.statistics.conversion.level}
												{include file="manage_kworks/kwork_item_rating_value.tpl" level=$post.statistics.conversion.level value=$post.statistics.conversion.user_percent.good}
											{else}
												<span class="fw600">{'noData'|l:"pages/manage-kworks/kwork-item"}</span>
											{/if}
											{* #value *}
											{* tooltip *}
											<div class="dib tooltip_circle tooltip_circle--gray-border-field tooltip_circle--size14 tooltip_circle--hover tooltipster ml5"
												{if $post.statistics.conversion.level}
													data-tooltip-content="#conversion-{$post.PID}"
													data-tooltip-side="bottom"
													data-kwork-id="{$post.PID}"
													data-tooltip-width="auto"
													data-metric="{UserStatisticManager::METRIC_REVIEW_RATING}"
												{else}
													data-tooltip-text="{"doNotHaveEnoughDataForThisRating"|l:"pages/manage-kworks/kwork-item"}"
													data-tooltip-side="right"
													data-tooltip-interactive="true"
												{/if}
												data-tooltip-theme="light">
												{if $post.statistics.conversion.level}
													<div class="d-none">
														<div id="conversion-{$post.PID}" class="kwork-item-tooltip-content">
															{include file="manage_kworks/tooltip_conversion.tpl"}
														</div>
													</div>
												{/if}
												?
											</div>
											{* #tooltip *}
										</div>
									</div>
									{* #Конверсия *}
								{else}
									<div class="new-manage-kworks-item__stats-rating-dummy">
										{"kworkRatingTextDummy"|l:"pages/manage-kworks/kwork-item"}
									</div>
								{/if}
							</div>
							<div class="new-manage-kworks-item__metrics">
								<div class="new-manage-kworks-item__metrics-item">
									<img class="kwork-icon icon-eye" src="{"/icons/icon-eye-16.svg"|cdnImageUrl}" width="17" height="16" alt="">
									{if $post.viewcount > 0}
										<span>{$post.viewcount|stripslashes|zero}</span>
									{else}
										<span>0</span>
									{/if}
								</div>
								<div class="new-manage-kworks-item__metrics-item">
									<img class="kwork-icon icon-cart" src="{"/icons/icon-cart-16.svg"|cdnImageUrl}" width="16" height="16" alt="">
									{if $post.done_order_count > 0}
										<span>{$post.done_order_count|zero}</span>
									{else}
										<span>0</span>
									{/if}
								</div>
								<div class="new-manage-kworks-item__metrics-item">
									<img class="kwork-icon icon-earn" src="{"/icons/icon-earn-14.svg"|cdnImageUrl}" width="14" height="14" alt="">
									{if $post.rev > 0}
										<span>{include file="utils/currency.tpl" lang=$actor->lang total=$post.rev}</span>
									{else}
										<span>0</span>
									{/if}
								</div>
								<span class="tooltip_circle tooltip_circle--gray-border-field tooltip_circle--size14 tooltip_circle--hover tooltipster ml9"
									data-tooltip-side="right"
									data-tooltip-text="{"activityInfoTooltip"|l:"pages/manage-kworks/kwork-item"}"
									data-tooltip-interactive="true"
									data-tooltip-theme="light">
								?
							</span>
							</div>
						</div>
						{* #Мобильная статистика *}
					</b-collapse>
				</div>
			{/if}
			{if $isDraft}
				<div class="new-manage-kworks-item__notify notify-draft">
					<div class="new-manage-kworks-item__notify-title">
						<img class="kwork-icon icon-kwork-draft" src="{"/icons/icon-kwork-draft.svg"|cdnImageUrl}" width="24" height="24" alt="">
						<div class="flex-grow-1">
							<span class="fw600">{"draft"|l:"pages/manage-kworks/kwork-item"}</span>&#32;
							<span class="m-hidden notify-title-desktop">{"newKworkNotCompleteYet"|l:"pages/manage-kworks/kwork-item"}</span>
						</div>
						<a class="fw600 ml10 notify-title-desktop-link" href="{$baseurl}/new?draft_id={$post.PID}{if $post.lang == Translations::EN_LANG}&lang={Translations::EN_LANG}{/if}">{"kworkNotCompleteYetLink"|l:"pages/manage-kworks/kwork-item"}</a>
					</div>
				</div>
			{/if}
			{if !$isDraft && ($post.is_need_update_price || $post.is_need_update_links || $post.is_need_update_packages || $post.is_need_update_package_prices || $post.is_need_update || $post.is_need_update_volume || $post.is_need_update_translates || $post.is_need_add_portfolio || $post.outsider_reason_hint || $post.rejectFieldsString) }
				{if $post.outsider_reason_hint}
					<div class="new-manage-kworks-item__notify notify-outsider">
						<div v-b-toggle="'collapse-upgrade-{$post.PID}'" class="new-manage-kworks-item__notify-title">
							<img class="kwork-icon icon-info" src="{"/icons/icon-info-24.svg"|cdnImageUrl}" width="24" height="24" alt="">
							<span class="m-visible fw600">{'suggestions'|l:"pages/manage-kworks/kwork-item"}</span>
							<span class="m-hidden notify-title-desktop">{$post.outsider_reason_hint}</span>
						</div>
						<b-collapse id="collapse-upgrade-{$post.PID}" class="new-manage-kworks-item__notify-body">
							{$post.outsider_reason_hint}
						</b-collapse>
					</div>
				{/if}
				{if $post.is_need_update_price}
					{include file="manage_kworks/tooltip_price.tpl" assign="tooltip"}
					{$upgrageText = {'adviceKworkPrice'|l:"pages/manage-kworks/kwork-item"}}
				{elseif $post.is_need_update_packages}
					{include file="manage_kworks/tooltip_packages.tpl" assign="tooltip"}
					{$upgrageText = {'adviceKworkEdit'|l:"pages/manage-kworks/kwork-item"}}
				{elseif $post.is_need_update_package_prices}
					{include file="manage_kworks/tooltip_package_prices.tpl" kworkLang=$post.lang assign="tooltip"}
					{$upgrageText = {'advicePackagesPrice'|l:"pages/manage-kworks/kwork-item"}}
				{elseif $post.is_need_update_demofile}
					{include file="manage_kworks/tooltip_need_update_demofile.tpl" assign="tooltip"}
					{$upgrageText = {'adviceReplaceDemoReport'|l:"pages/manage-kworks/kwork-item"}}
				{elseif $post.is_need_update_links}
					{$tooltip = {'isNeedUpdateLinksWarningMore'|l:"pages/kwork/kwork-warnings"}}
					{$upgrageText = {'isNeedUpdateLinksWarning'|l:"pages/kwork/kwork-warnings"}}
				{/if}
				{if $post.rejectFieldsString}
					{$upgrageText = $post.rejectFieldsString}
				{/if}
				{if $upgrageText}
					<div class="new-manage-kworks-item__notify importance-medium">
						<div v-b-toggle="'collapse-change-{$post.PID}'" class="new-manage-kworks-item__notify-title">
							<img class="kwork-icon icon-triangle-orange" src="{"/icons/triangle-orange.svg"|cdnImageUrl}" width="24" height="24" alt="">
							<span class="fw600 m-visible">{'correctionsRequired'|l:"pages/manage-kworks/kwork-item"}</span>
							<span class="m-hidden notify-title-desktop">
								<span class="fw600">{'editThis'|l:"pages/manage-kworks/kwork-item"}:</span>&#32;
									{$upgrageText}&#32;
									{if $tooltip}
										<span class="tooltipster kw-link-dashed"
											data-tooltip-text="{$tooltip|replace:'"':'&quot;'}">
											{'learnMore'|l:"pages/manage-kworks/kwork-item"}
										</span>
									{/if}
							</span>
							<a href="{$href}" class="m-hidden notify-title-desktop-link">{"goToRevisions"|l:"pages/manage-kworks/kwork-item"}</a>
						</div>
						<b-collapse id="collapse-change-{$post.PID}" class="new-manage-kworks-item__notify-body">
							{$upgrageText}&#32;
							{if $tooltip}
								<span class="tooltipster kw-link-dashed"
									  data-tooltip-text="{$tooltip|replace:'"':'&quot;'}">
									{'learnMore'|l:"pages/manage-kworks/kwork-item"}
								</span>
							{/if}
							<div class="mt15 m-visible">
								<a href={$href}" class="kw-button kw-button--green kw-button--green-border kw-button--size-40 kw-button--width-full-mobile">{"goToRevisions"|l:"pages/manage-kworks/kwork-item"}</a>
							</div>
						</b-collapse>
					</div>
				{/if}
			{else}
				{if $post.is_need_update || $post.is_need_update_volume || $post.is_need_update_translates || $post.is_need_add_portfolio || $isPaused}
					{if $isPaused}
						{if $post.is_portfolio_limited}
							{$countPortfolio = $posts[i].portfolio_fill_percent.needPortfolio}
							{if !$countPortfolio}
								{$countPortfolio = ''}
							{/if}
							{$customUpdateNotice = {"uploadMoreWorkSamples"|l:"pages/manage-kworks/kwork-item":["limitedPercent" => PortfolioManager::LIMITED_FILL_PERCENT, "countPortfolio" => $countPortfolio, "countPortfolioWord" => $posts[i].needPortfolioWord]}}
							{$articleId = 542}
							{if !Translations::isDefaultLang()}
								{$articleId = 1695}
							{/if}
							{$faqLink = "$baseurl/faq?role=5&article=$articleId"}
						{elseif $post.is_invalid_links}
                            {$editKworkButton = true}
							{$customUpdateNotice = {'publicHtmlThemesManageKworksListTpl14'|l:"legacy-translations"}}
						{elseif $post.orders_inprogress_limit}
							{assign var=pauseOn value=Localization\LocalizationManager::lp("countOrdersInprogressLimit", "pages/manage-kworks/list", $post.orders_inprogress_limit, $post.orders_inprogress_limit)}
							{assign var=pauseOff value=Localization\LocalizationManager::lp("countOrdersInprogressPauseOff", "pages/manage-kworks/list", $post.orders_inprogress_pause_off, $post.orders_inprogress_pause_off)}
							{$customUpdateNotice = {"kworkPausedBecauseManyCurrentlyActiveOrdersOfThisKwork"|l:"pages/manage-kworks/list":["countKworksNow" => $pauseOn, "countKworksNeed" => $pauseOff]}}
						{/if}
					{else}
						{$editKworkButton = true}
						{if $post.is_need_update_volume}
							{include file="manage_kworks/tooltip_volume.tpl" assign="tooltip"}
						{elseif $post.is_need_update_translates}
							{include file="manage_kworks/tooltip_need_update_translate.tpl" assign="tooltip"}
						{elseif $post.is_need_fill_attribute}
							{include file="manage_kworks/tooltip_fill_attributes.tpl" assign="tooltip"}
						{elseif $post.is_need_add_portfolio}
							{$editKworkButton = false}
							{assign var=customUpdateNotice value=Localization\LocalizationManager::translate("addMorePortfolio", "pages/manage-kworks/kwork-item")}
							{include file="manage_kworks/tooltip_fill_portfolio.tpl" assign="tooltip"}
						{else}
							{include file="manage_kworks/tooltip_need_update.tpl" assign="tooltip"}
						{/if}
					{/if}

					<div class="new-manage-kworks-item__notify importance-high">
						<div class="new-manage-kworks-item__notify-title">
							<img class="kwork-icon icon-triangle-red" src="{"/icons/triangle-red.svg"|cdnImageUrl}" width="24" height="24" alt="">
							<div class="flex-grow-1">
								<span class="fw600">
									{$customUpdateNotice|default:(Localization\LocalizationManager::translate("pleaseUpdateThisKwork", "pages/manage-kworks/kwork-item"))}
                                    {if $faqLink}
	                                    &#32;<a href="{$faqLink}" class="fw600 kw-link-underline" target="_blank">{"learnMoreUploadMoreWorkSamples"|l:"pages/manage-kworks/kwork-item"}</a>
                                    {/if}
								</span>&#32;
								{if $tooltip}
									<span class="fw600 kw-link-dashed tooltipster"
										data-tooltip-text="{$tooltip|replace:'"':'&quot;'}">{"whyUpdateThisKwork"|l:"pages/manage-kworks/kwork-item"}
									</span>
								{/if}
								{if $editKworkButton}
									<div class="mt15 m-visible">
										<a href={$href}" class="kw-button kw-button--green kw-button--green-border kw-button--size-40 kw-button--width-full-mobile">{"goToRevisions"|l:"pages/manage-kworks/kwork-item"}</a>
									</div>
								{/if}
							</div>
							{if $editKworkButton}
								<a href="{$href}" class="m-hidden notify-title-desktop-link">{"goToRevisions"|l:"pages/manage-kworks/kwork-item"}</a>
							{/if}
						</div>
					</div>
				{/if}
			{/if}
		</div>
		{* /Место для уведомлений *}
	</div>
{/strip}
