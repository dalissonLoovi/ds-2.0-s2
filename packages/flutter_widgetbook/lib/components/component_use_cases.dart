import 'package:widgetbook/widgetbook.dart';

import 'alert_use_cases.dart';
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

/// Phase 2 components (mode app-cliente), in the order the app needs them.
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
      ],
    );
