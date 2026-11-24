/// Loovi Design System S2 — Flutter widgets (mode app-cliente).
///
/// Every widget paints from `LooviTokens` (package loovi_tokens). Props and
/// variants mirror the DS seed; descriptions and Figma nodeIds live in
/// [LooviSeedCatalog].
library;

export 'package:loovi_tokens/loovi_tokens.dart';

export 'src/foundation/loovi_icon.dart';
export 'src/foundation/loovi_tap_target.dart';
export 'src/generated/loovi_icon_names.g.dart';
export 'src/generated/seed_catalog.g.dart';
// WIDGETS — one export per component (phase 2 wave).
export 'src/widgets/alert/loovi_alert.dart';
// Internal helpers shared between widgets stay out of the public API.
export 'src/widgets/app_header/loovi_app_header.dart' hide LooviHeaderIconAction;
export 'src/widgets/bottom_sheet/loovi_bottom_sheet.dart';
export 'src/widgets/bottom_sheet/loovi_bottom_sheet_header.dart';
export 'src/widgets/button/loovi_button.dart';
export 'src/widgets/modal/loovi_modal.dart';
export 'src/widgets/modal/loovi_modal_header.dart';
export 'src/widgets/section_header/loovi_section_header.dart';
export 'src/widgets/checkbox/loovi_checkbox.dart' hide LooviFocusRingPainter;
export 'src/widgets/chip_clickable/loovi_chip_clickable.dart';
export 'src/widgets/chip_tag/loovi_chip_tag.dart';
export 'src/widgets/input/loovi_input.dart' hide LooviInputFieldColors, LooviInputFloatingLabel;
export 'src/widgets/input_password/loovi_input_password.dart';
export 'src/widgets/input_textarea/loovi_input_textarea.dart';
export 'src/widgets/link/loovi_link.dart';
export 'src/widgets/list/loovi_list.dart';
export 'src/widgets/list_item/loovi_list_item.dart';
export 'src/widgets/navigation_bar/loovi_navigation_bar.dart';
export 'src/widgets/navigation_bar/loovi_navigation_bar_item.dart';
export 'src/widgets/radio_button/loovi_radio_button.dart';
export 'src/widgets/switch/loovi_switch.dart';
export 'src/widgets/accordion/loovi_accordion.dart';
export 'src/widgets/avatar/loovi_avatar.dart';
export 'src/widgets/badge/loovi_badge.dart';
export 'src/widgets/banner/loovi_banner.dart';
export 'src/widgets/divider_horizontal/loovi_divider_horizontal.dart';
export 'src/widgets/loading_spinner/loovi_loading_spinner.dart';
export 'src/widgets/offer_product_card/loovi_offer_product_card.dart';
export 'src/widgets/quick_access_tile/loovi_quick_access_tile.dart';
export 'src/widgets/referral_discount_card/loovi_referral_discount_card.dart';
export 'src/widgets/tabs/loovi_tabs.dart';
export 'src/widgets/toast/loovi_toast.dart';
export 'src/widgets/vehicle_summary_card/loovi_vehicle_summary_card.dart';
export 'src/widgets/autocomplete/loovi_autocomplete.dart';
export 'src/widgets/bottom_sheet_check_item/loovi_bottom_sheet_check_item.dart';
export 'src/widgets/chip_group/loovi_chip_group.dart';
export 'src/widgets/date_picker_select/loovi_date_picker_select.dart';
export 'src/widgets/date_picker_select_item/loovi_date_picker_select_item.dart';
export 'src/widgets/input_date_picker/loovi_input_date_picker.dart';
export 'src/widgets/input_number/loovi_input_number.dart';
export 'src/widgets/input_number_trailing_payment_mark/loovi_input_number_trailing_payment_mark.dart';
export 'src/widgets/input_select/loovi_input_select.dart';
export 'src/widgets/modal_check_item/loovi_modal_check_item.dart' hide LooviCheckItemRow;
export 'src/widgets/progress_bar/loovi_progress_bar.dart';
export 'src/widgets/radio_button_card/loovi_radio_button_card.dart';
export 'src/widgets/search_bar/loovi_search_bar.dart';
export 'src/widgets/search_view_fullscreen/loovi_search_view_fullscreen.dart';
export 'src/widgets/select_country/loovi_select_country.dart';
export 'src/widgets/step_progress_indicator/loovi_step_progress_indicator.dart';
export 'src/widgets/step_progress_segment/loovi_step_progress_segment.dart';
export 'src/widgets/stepper_primary/loovi_stepper_primary.dart';
export 'src/widgets/tooltip/loovi_tooltip.dart';
export 'src/widgets/tooltip_rich/loovi_tooltip_rich.dart';
export 'src/widgets/verification_code_input/loovi_verification_code_input.dart';
export 'src/widgets/verification_code_input_item/loovi_verification_code_input_item.dart';
export 'src/widgets/vertical_stepper/loovi_vertical_stepper.dart';
export 'src/widgets/vertical_stepper_item/loovi_vertical_stepper_item.dart';
