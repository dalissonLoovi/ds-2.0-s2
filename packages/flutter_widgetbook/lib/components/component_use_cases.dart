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
      ],
    );
