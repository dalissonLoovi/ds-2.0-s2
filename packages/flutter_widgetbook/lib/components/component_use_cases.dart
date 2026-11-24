import 'package:widgetbook/widgetbook.dart';

import 'alert_use_cases.dart';
import 'accordion_use_cases.dart';
import 'avatar_use_cases.dart';
import 'badge_use_cases.dart';
import 'banner_use_cases.dart';
import 'divider_horizontal_use_cases.dart';
import 'loading_spinner_use_cases.dart';
import 'offer_product_card_use_cases.dart';
import 'quick_access_tile_use_cases.dart';
import 'referral_discount_card_use_cases.dart';
import 'tabs_use_cases.dart';
import 'toast_use_cases.dart';
import 'vehicle_summary_card_use_cases.dart';
import 'app_header_use_cases.dart';
import 'bottom_sheet_use_cases.dart';
import 'button_use_cases.dart';
import 'modal_use_cases.dart';
import 'section_header_use_cases.dart';
import 'checkbox_use_cases.dart';
import 'chip_clickable_use_cases.dart';
import 'chip_tag_use_cases.dart';
import 'input_password_use_cases.dart';
import 'input_textarea_use_cases.dart';
import 'input_use_cases.dart';
import 'link_use_cases.dart';
import 'list_item_use_cases.dart';
import 'list_use_cases.dart';
import 'navigation_bar_use_cases.dart';
import 'radio_button_use_cases.dart';
import 'switch_use_cases.dart';
import 'autocomplete_use_cases.dart';
import 'check_item_use_cases.dart';
import 'chip_group_use_cases.dart';
import 'date_picker_select_item_use_cases.dart';
import 'date_picker_select_use_cases.dart';
import 'input_date_picker_use_cases.dart';
import 'input_number_trailing_payment_mark_use_cases.dart';
import 'input_number_use_cases.dart';
import 'input_select_use_cases.dart';
import 'progress_bar_use_cases.dart';
import 'radio_button_card_use_cases.dart';
import 'search_bar_use_cases.dart';
import 'search_view_fullscreen_use_cases.dart';
import 'select_country_use_cases.dart';
import 'step_progress_indicator_use_cases.dart';
import 'step_progress_segment_use_cases.dart';
import 'stepper_primary_use_cases.dart';
import 'tooltip_rich_use_cases.dart';
import 'tooltip_use_cases.dart';
import 'verification_code_input_use_cases.dart';
import 'vertical_stepper_item_use_cases.dart';
import 'vertical_stepper_use_cases.dart';
import 'avatar_group_use_cases.dart';
import 'brand_logo_use_cases.dart';
import 'card_horizontal_use_cases.dart';
import 'card_items_use_cases.dart';
import 'card_stacked_use_cases.dart';
import 'carousel_pagination_item_use_cases.dart';
import 'carousel_use_cases.dart';
import 'dashboard_card_primary_use_cases.dart';
import 'dashboard_card_secondary_use_cases.dart';
import 'feature_steps_item_use_cases.dart';
import 'feature_steps_use_cases.dart';
import 'list_action_dropdown_item_use_cases.dart';
import 'list_action_dropdown_use_cases.dart';
import 'list_item_image_thumbnail_use_cases.dart';
import 'list_item_leading_illustration_use_cases.dart';
import 'list_item_leading_monogram_use_cases.dart';
import 'list_item_leading_payment_mark_use_cases.dart';
import 'list_item_state_layer_use_cases.dart';
import 'list_item_trailing_illustration_use_cases.dart';
import 'list_item_video_thumbnail_use_cases.dart';
import 'overlay_use_cases.dart';
import 'payment_method_mark_use_cases.dart';
import 'text_header_use_cases.dart';
import 'vehicle_confirm_card_use_cases.dart';

/// Components (mode app-cliente): wave 1 in the order the app needs them, then wave 2.
WidgetbookFolder componentsFolder() => WidgetbookFolder(
      name: 'Components',
      children: [
        looviButtonComponent(),
        looviLinkComponent(),
        looviInputComponent(),
        looviInputPasswordComponent(),
        looviInputTextAreaComponent(),
        looviCheckboxComponent(),
        looviRadioButtonComponent(),
        looviSwitchComponent(),
        looviListItemComponent(),
        looviListComponent(),
        looviChipTagComponent(),
        looviChipClickableComponent(),
        looviAppHeaderComponent(),
        looviSectionHeaderComponent(),
        looviAlertComponent(),
        looviModalComponent(),
        looviModalHeaderComponent(),
        looviBottomSheetComponent(),
        looviBottomSheetHeaderComponent(),
        looviNavigationBarComponent(),
        looviNavigationBarItemComponent(),
        // Wave 2 (2026-11-24)
        looviLoadingSpinnerComponent(),
        looviBadgeComponent(),
        looviAvatarComponent(),
        looviDividerHorizontalComponent(),
        looviTabItemComponent(),
        looviTabsPrimaryComponent(),
        looviTabsSecondaryComponent(),
        looviTabsSegmentedComponent(),
        looviAccordionComponent(),
        looviToastComponent(),
        looviBannerComponent(),
        looviQuickAccessTileComponent(),
        looviVehicleSummaryCardComponent(),
        looviOfferProductCardComponent(),
        looviReferralDiscountCardComponent(),
        // Wave 3 (2026-11-24)
        looviInputSelectComponent(),
        looviInputDatePickerComponent(),
        looviDatePickerSelectComponent(),
        looviDatePickerSelectItemComponent(),
        looviInputNumberComponent(),
        looviSelectCountryComponent(),
        looviInputNumberTrailingPaymentMarkComponent(),
        looviAutocompleteComponent(),
        looviSearchBarComponent(),
        looviSearchViewFullscreenComponent(),
        looviVerificationCodeInputComponent(),
        looviVerificationCodeInputItemComponent(),
        looviRadioButtonCardComponent(),
        looviChipGroupComponent(),
        looviModalCheckItemComponent(),
        looviBottomSheetCheckItemComponent(),
        looviProgressBarComponent(),
        looviStepProgressIndicatorComponent(),
        looviStepProgressSegmentComponent(),
        looviStepperPrimaryComponent(),
        looviVerticalStepperComponent(),
        looviVerticalStepperItemComponent(),
        looviTooltipComponent(),
        looviTooltipRichComponent(),
        // Wave 4 (2026-11-24)
        looviCardOutlinedItemComponent(),
        looviCardElevatedItemComponent(),
        looviCardFilledItemComponent(),
        looviCardHorizontalComponent(),
        looviCardStackedComponent(),
        looviDashboardCardPrimaryComponent(),
        looviDashboardCardSecondaryComponent(),
        looviVehicleConfirmCardComponent(),
        looviCarouselComponent(),
        looviCarouselPaginationItemComponent(),
        looviFeatureStepsComponent(),
        looviFeatureStepsItemComponent(),
        looviAvatarGroupComponent(),
        looviTextHeaderComponent(),
        looviOverlayComponent(),
        looviListActionDropdownComponent(),
        looviListActionDropdownItemComponent(),
        looviListItemLeadingMonogramComponent(),
        looviListItemStateLayerComponent(),
        looviListItemImageThumbnailComponent(),
        looviListItemVideoThumbnailComponent(),
        looviListItemLeadingIllustrationComponent(),
        looviListItemTrailingIllustrationComponent(),
        looviListItemLeadingPaymentMarkComponent(),
        looviBrandLogoComponent(),
        looviPaymentMethodMarkComponent(),
      ],
    );
