/**
 * Fail CI when React variant unions diverge from seed JSON variants.
 * Handwritten W0 components are checked; scaffolds are skipped until polished.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const JSON_PATH = path.join(ROOT, 'design-system-tokens.storybook.updated.v2.json');

const CHECK = {
  Button: {
    file: 'packages/react/src/components/Button/Button.tsx',
    axes: {
      variant: ['solid', 'outline', 'text'],
      size: ['sm', 'md', 'lg'],
      intent: ['primary', 'success', 'danger', 'secondary'],
      state: ['default', 'hover', 'focus', 'pressed', 'selected', 'loading'],
    },
  },
  Input: {
    file: 'packages/react/src/components/Input/Input.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'error', 'disabled'],
      content: ['value', 'placeholder', 'label'],
      appearance: ['default', 'inverse'],
    },
  },
  ChipTag: {
    file: 'packages/react/src/components/ChipTag/ChipTag.tsx',
    axes: {
      size: ['sm', 'md'],
      intent: ['info', 'system', 'success', 'warning', 'danger', 'outline'],
      width: ['hug', 'fill'],
      state: ['default', 'disabled'],
      emphasis: ['strong', 'soft'],
    },
  },
  ChipClickable: {
    file: 'packages/react/src/components/ChipClickable/ChipClickable.tsx',
    axes: {
      size: ['sm', 'md'],
      state: ['default', 'hover', 'pressed', 'selected', 'disabled'],
      intent: ['info', 'system', 'success', 'warning', 'danger', 'outline', 'soft'],
      width: ['hug', 'fill'],
    },
  },
  Alert: {
    file: 'packages/react/src/components/Alert/Alert.tsx',
    axes: {
      appearance: ['default', 'inverse'],
      status: ['system', 'info', 'success', 'danger', 'warning'],
    },
  },
  Toast: {
    file: 'packages/react/src/components/Toast/Toast.tsx',
    axes: {
      status: ['system', 'info', 'success', 'danger', 'warning'],
    },
  },
  Modal: {
    file: 'packages/react/src/components/Modal/Modal.tsx',
    axes: {
      platform: ['web', 'mobile', 'mobile-landscape'],
    },
  },
  Link: {
    file: 'packages/react/src/components/Link/Link.tsx',
    axes: {
      size: ['lg', 'md', 'sm'],
      state: ['default', 'hover', 'focus', 'active', 'visited', 'disabled'],
      appearance: ['default', 'inverse'],
    },
  },
  Checkbox: {
    file: 'packages/react/src/components/Checkbox/Checkbox.tsx',
    axes: {
      state: ['default', 'focus', 'disabled'],
      checked: ['false', 'true', 'mixed'],
    },
  },
  RadioButton: {
    file: 'packages/react/src/components/RadioButton/RadioButton.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'disabled'],
      checked: ['false', 'true'],
    },
  },
  RadioButtonCard: {
    file: 'packages/react/src/components/RadioButtonCard/RadioButtonCard.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'disabled'],
      checked: ['false', 'true'],
    },
  },
  Switch: {
    file: 'packages/react/src/components/Switch/Switch.tsx',
    axes: {
      size: ['md', 'sm'],
      state: ['default', 'focus', 'disabled'],
      checked: ['false', 'true'],
    },
  },
  InputTextArea: {
    file: 'packages/react/src/components/InputTextArea/InputTextArea.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'error', 'disabled'],
      content: ['value', 'placeholder', 'label'],
      leadingIcon: ['false', 'true'],
      trailingIcon: ['false', 'true'],
      appearance: ['default', 'inverse'],
    },
  },
  InputPassword: {
    file: 'packages/react/src/components/InputPassword/InputPassword.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'error', 'disabled'],
      content: ['value', 'placeholder', 'label'],
      leadingIcon: ['true', 'false'],
      visibility: ['hidden', 'visible'],
      appearance: ['default', 'inverse'],
    },
  },
  InputNumber: {
    file: 'packages/react/src/components/InputNumber/InputNumber.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'error', 'disabled'],
      content: ['value', 'placeholder', 'label'],
      leadingIcon: ['true', 'false'],
      trailingIcon: ['true', 'false'],
      appearance: ['default', 'inverse'],
    },
  },
  InputSelect: {
    file: 'packages/react/src/components/InputSelect/InputSelect.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'error', 'disabled'],
      content: ['value', 'placeholder', 'label'],
      leadingIcon: ['true', 'false'],
      appearance: ['default', 'inverse'],
    },
  },
  InputDatePicker: {
    file: 'packages/react/src/components/InputDatePicker/InputDatePicker.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'error', 'disabled'],
      content: ['value', 'placeholder', 'label'],
      leadingIcon: ['true', 'false'],
      appearance: ['default', 'inverse'],
    },
  },
  SelectCountry: {
    file: 'packages/react/src/components/SelectCountry/SelectCountry.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'disabled'],
      size: ['sm', 'md'],
      expanded: ['false', 'true'],
    },
  },
  SearchBar: {
    file: 'packages/react/src/components/SearchBar/SearchBar.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'pressed', 'disabled'],
      content: ['placeholder', 'value'],
    },
  },
  Autocomplete: {
    file: 'packages/react/src/components/Autocomplete/Autocomplete.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'error', 'disabled'],
      content: ['empty', 'query', 'selected'],
      expanded: ['false', 'true'],
      appearance: ['default', 'inverse'],
    },
  },
  VerificationCodeInput: {
    file: 'packages/react/src/components/VerificationCodeInput/VerificationCodeInput.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'error', 'disabled'],
    },
  },
  VerificationCodeInputItem: {
    file: 'packages/react/src/components/VerificationCodeInputItem/VerificationCodeInputItem.tsx',
    axes: {
      state: ['default', 'hover', 'focus', 'error', 'disabled'],
    },
  },
  DatePickerSelect: {
    file: 'packages/react/src/components/DatePickerSelect/DatePickerSelect.tsx',
    axes: {
      format: ['day-month-year', 'day-month', 'month-year', 'year'],
      state: ['default', 'hover', 'focus', 'disabled'],
    },
  },
  DatePickerSelectItem: {
    file: 'packages/react/src/components/DatePickerSelectItem/DatePickerSelectItem.tsx',
    axes: {
      unit: ['day', 'month', 'year'],
      state: ['default', 'hover', 'focus', 'disabled'],
      expanded: ['false', 'true'],
    },
  },

  LoadingSpinner: {
    file: 'packages/react/src/components/LoadingSpinner/LoadingSpinner.tsx',
    axes: { size: ['sm', 'md', 'lg'] },
  },
  Badge: {
    file: 'packages/react/src/components/Badge/Badge.tsx',
    axes: {
      size: ['sm', 'lg'],
      content: ['dot', 'count', 'overflow'],
    },
  },
  ProgressBar: {
    file: 'packages/react/src/components/ProgressBar/ProgressBar.tsx',
    axes: { size: ['md', 'sm'] },
  },
  Banner: {
    file: 'packages/react/src/components/Banner/Banner.tsx',
    axes: { status: ['success', 'warning', 'info', 'danger'] },
  },
  Tooltip: {
    file: 'packages/react/src/components/Tooltip/Tooltip.tsx',
    axes: {
      placement: ['top-center','top-left','top-right','bottom-center','bottom-left','bottom-right'],
    },
  },
  TooltipRich: {
    file: 'packages/react/src/components/TooltipRich/TooltipRich.tsx',
    axes: {
      placement: ['top-center','top-left','top-right','bottom-center','bottom-left','bottom-right'],
    },
  },
  Overlay: {
    file: 'packages/react/src/components/Overlay/Overlay.tsx',
    axes: {
      type: ['modal', 'bottom-sheet'],
      platform: ['mobile', 'web'],
    },
  },
  BottomSheet: {
    file: 'packages/react/src/components/BottomSheet/BottomSheet.tsx',
    axes: { header: ['none', 'sheet-header'] },
  },
  BottomSheetHeader: {
    file: 'packages/react/src/components/BottomSheetHeader/BottomSheetHeader.tsx',
    axes: { appearance: ['default'] },
  },
  BottomSheetCheckItem: {
    file: 'packages/react/src/components/BottomSheetCheckItem/BottomSheetCheckItem.tsx',
    axes: {},
  },
  TextHeader: {
    file: 'packages/react/src/components/TextHeader/TextHeader.tsx',
    axes: {
      size: ['large', 'medium', 'small'],
      alignment: ['left', 'center'],
    },
  },
  SectionHeader: {
    file: 'packages/react/src/components/SectionHeader/SectionHeader.tsx',
    axes: {
      emphasis: ['primary', 'secondary'],
      showAction: ['false', 'true'],
    },
  },
  OrganizationHeader: {
    file: 'packages/react/src/components/OrganizationHeader/OrganizationHeader.tsx',
    axes: {},
  },
  TabItem: {
    file: 'packages/react/src/components/TabItem/TabItem.tsx',
    axes: {
      variant: ['primary', 'secondary', 'segmented'],
      state: ['default', 'hover', 'selected', 'disabled'],
      platform: ['web', 'mobile'],
      appearance: ['default', 'inverse'],
    },
  },
  NavigationBarItem: {
    file: 'packages/react/src/components/NavigationBarItem/NavigationBarItem.tsx',
    axes: {
      appearance: ['default', 'inverse'],
      state: ['default', 'hover', 'focus', 'pressed'],
      badge: ['none', 'count', 'dot'],
      selected: ['false', 'true'],
      showLabel: ['true', 'false'],
    },
  },
  NavigationDrawerItem: {
    file: 'packages/react/src/components/NavigationDrawerItem/NavigationDrawerItem.tsx',
    axes: {
      appearance: ['default', 'inverse'],
      state: ['default', 'hover', 'focus', 'pressed'],
      selected: ['false', 'true'],
    },
  },
  NavigationRailCompactItem: {
    file: 'packages/react/src/components/NavigationRailCompactItem/NavigationRailCompactItem.tsx',
    axes: {
      appearance: ['default', 'inverse'],
      state: ['default', 'hover', 'focus', 'pressed'],
      badge: ['none', 'count', 'dot'],
      selected: ['false', 'true'],
      showLabel: ['true', 'false'],
    },
  },
  NavigationRailExpandedItem: {
    file: 'packages/react/src/components/NavigationRailExpandedItem/NavigationRailExpandedItem.tsx',
    axes: {
      appearance: ['default', 'inverse'],
      state: ['default', 'hover', 'focus', 'pressed'],
      hierarchy: ['default', 'nav-tree'],
      badge: ['none', 'count', 'dot'],
      selected: ['false', 'true'],
    },
  },
  BreadcrumbItem: {
    file: 'packages/react/src/components/BreadcrumbItem/BreadcrumbItem.tsx',
    axes: {
      size: ['sm', 'md'],
      type: ['link', 'overflow'],
      state: ['default', 'hover', 'focus', 'pressed', 'current', 'skeleton', 'open'],
    },
  },
  TabsPrimary: {
    file: 'packages/react/src/components/TabsPrimary/TabsPrimary.tsx',
    axes: {
      itemCount: ['2', '3', '4', '5'],
      platform: ['web', 'mobile'],
      alignment: ['left', 'center'],
      appearance: ['default', 'inverse'],
    },
  },
  TabsSecondary: {
    file: 'packages/react/src/components/TabsSecondary/TabsSecondary.tsx',
    axes: {
      itemCount: ['2', '3', '4', '5'],
      platform: ['web', 'mobile'],
      alignment: ['left', 'center'],
    },
  },
  TabsSegmented: {
    file: 'packages/react/src/components/TabsSegmented/TabsSegmented.tsx',
    axes: {
      itemCount: ['2', '3', '4', '5'],
      platform: ['web', 'mobile'],
      alignment: ['left', 'center'],
    },
  },
  Breadcrumb: {
    file: 'packages/react/src/components/Breadcrumb/Breadcrumb.tsx',
    axes: { size: ['md', 'sm'] },
  },
  NavigationBar: {
    file: 'packages/react/src/components/NavigationBar/NavigationBar.tsx',
    axes: {
      itemCount: ['3', '4', '5'],
      appearance: ['default', 'inverse'],
      layout: ['flush', 'floating'],
    },
  },
  NavigationDrawer: {
    file: 'packages/react/src/components/NavigationDrawer/NavigationDrawer.tsx',
    axes: {
      appearance: ['default', 'inverse'],
      itemCount: ['3', '4', '5', '6'],
    },
  },
  NavigationRailCompact: {
    file: 'packages/react/src/components/NavigationRailCompact/NavigationRailCompact.tsx',
    axes: {
      appearance: ['default', 'inverse'],
      alignment: ['top', 'middle'],
      itemCount: ['3', '4', '5', '6'],
    },
  },
  NavigationRailExpanded: {
    file: 'packages/react/src/components/NavigationRailExpanded/NavigationRailExpanded.tsx',
    axes: {
      appearance: ['default', 'inverse'],
      alignment: ['top', 'middle'],
      itemCount: ['3', '4', '5', '6'],
    },
  },
  NavigationRailExpandedTree: {
    file: 'packages/react/src/components/NavigationRailExpandedTree/NavigationRailExpandedTree.tsx',
    axes: {
      selectedItem: ['none', 'item-01', 'item-02', 'item-03', 'item-04'],
      level: ['default', 'second-level'],
      appearance: ['default', 'inverse'],
    },
  },
  AppHeader: {
    file: 'packages/react/src/components/AppHeader/AppHeader.tsx',
    axes: {
      layout: ['small-centered', 'small', 'medium', 'large'],
      appearance: ['default', 'inverse'],
      hierarchy: ['global', 'specific', 'super-app'],
    },
  },
  SystemHeader: {
    file: 'packages/react/src/components/SystemHeader/SystemHeader.tsx',
    axes: {
      appearance: ['default', 'inverse'],
      variant: ['default', 'simple'],
    },
  },
  DividerHorizontal: {
    file: 'packages/react/src/components/DividerHorizontal/DividerHorizontal.tsx',
    axes: {
      variant: ['full-width', 'inset', 'middle-inset', 'with-subhead'],
    },
  },
  DividerVertical: {
    file: 'packages/react/src/components/DividerVertical/DividerVertical.tsx',
    axes: {
      variant: ['full-width', 'inset', 'middle-inset'],
    },
  },
  Avatar: {
    file: 'packages/react/src/components/Avatar/Avatar.tsx',
    axes: {
      content: ['image', 'initials', 'placeholder'],
      size: ['micro', 'xs', 'sm', 'md', 'lg', 'xl'],
      state: ['default', 'hover', 'focus', 'disabled', 'loading'],
    },
  },
  AvatarGroup: {
    file: 'packages/react/src/components/AvatarGroup/AvatarGroup.tsx',
    axes: { size: ['micro', 'xs', 'sm', 'md', 'lg', 'xl'] },
  },
  Accordion: {
    file: 'packages/react/src/components/Accordion/Accordion.tsx',
    axes: {
      expanded: ['false', 'true'],
      state: ['default', 'disabled'],
      size: ['sm', 'md'],
      padding: ['padded', 'flush'],
    },
  },
  ListItemStateLayer: {
    file: 'packages/react/src/components/ListItemStateLayer/ListItemStateLayer.tsx',
    axes: { state: ['default', 'hover', 'focus', 'pressed', 'dragged'] },
  },
  ListItemLeadingMonogram: {
    file: 'packages/react/src/components/ListItemLeadingMonogram/ListItemLeadingMonogram.tsx',
    axes: {},
  },
  ListItemImageThumbnail: {
    file: 'packages/react/src/components/ListItemImageThumbnail/ListItemImageThumbnail.tsx',
    axes: {},
  },
  ListItemVideoThumbnail: {
    file: 'packages/react/src/components/ListItemVideoThumbnail/ListItemVideoThumbnail.tsx',
    axes: {},
  },
  ListItem: {
    file: 'packages/react/src/components/ListItem/ListItem.tsx',
    axes: {
      condition: ['1-line', '2-line', '3-line'],
      leading: ['none', 'monogram', 'icon', 'image', 'video', 'checkbox', 'radio', 'switch'],
      trailing: ['none', 'icon', 'checkbox', 'radio', 'switch'],
      showOverline: ['false', 'true'],
      showSupportingText: ['false', 'true'],
    },
  },
  List: {
    file: 'packages/react/src/components/List/List.tsx',
    axes: { type: ['plain', 'dropdown'] },
  },
  ListActionDropdownItem: {
    file: 'packages/react/src/components/ListActionDropdownItem/ListActionDropdownItem.tsx',
    axes: {
      state: ['default', 'hover', 'pressed', 'selected', 'focus', 'disabled'],
    },
  },
  ListActionDropdown: {
    file: 'packages/react/src/components/ListActionDropdown/ListActionDropdown.tsx',
    axes: {},
  },
  TableCell: {
    file: 'packages/react/src/components/TableCell/TableCell.tsx',
    axes: {
      type: ['header', 'primary', 'secondary', 'tertiary', 'slot'],
      state: ['default', 'hover', 'pressed', 'selected'],
    },
  },
  TableExpandCell: {
    file: 'packages/react/src/components/TableExpandCell/TableExpandCell.tsx',
    axes: {
      type: ['body', 'header'],
      state: ['default', 'hover', 'pressed', 'selected', 'focus', 'disabled'],
      showChevron: ['true', 'false'],
    },
  },
  TableRow: {
    file: 'packages/react/src/components/TableRow/TableRow.tsx',
    axes: {
      type: ['header', 'body'],
      cellCount: ['3', '4', '5', '6', '7', '8', '9'],
      state: ['default', 'hover', 'pressed', 'selected', 'focus'],
    },
  },
  Table: {
    file: 'packages/react/src/components/Table/Table.tsx',
    axes: { columns: ['3', '4', '5', '6', '7', '8', '9'] },
  },
  TableMobileCell: {
    file: 'packages/react/src/components/TableMobileCell/TableMobileCell.tsx',
    axes: {
      type: ['primary', 'secondary', 'tag', 'action', 'icon'],
      state: ['default', 'hover', 'pressed', 'selected'],
    },
  },
  TableMobile: {
    file: 'packages/react/src/components/TableMobile/TableMobile.tsx',
    axes: {
      state: ['default', 'hover', 'pressed'],
      interactive: ['false', 'true'],
      showTag: ['true', 'false'],
      columnCount: ['2', '3', '4', '5', '6'],
    },
  },
  PaginationItem: {
    file: 'packages/react/src/components/PaginationItem/PaginationItem.tsx',
    axes: {
      content: ['number', 'overflow'],
      state: ['default', 'hover', 'focus', 'disabled'],
      selected: ['false', 'true'],
    },
  },
  Pagination: {
    file: 'packages/react/src/components/Pagination/Pagination.tsx',
    axes: {
      position: ['start', 'middle', 'end'],
      size: ['lg', 'sm'],
    },
  },
  CarouselPaginationItem: {
    file: 'packages/react/src/components/CarouselPaginationItem/CarouselPaginationItem.tsx',
    axes: {
      itemCount: ['2', '3', '4', '5'],
      itemView: ['1', '2', '3', '4', '5'],
    },
  },
  Carousel: {
    file: 'packages/react/src/components/Carousel/Carousel.tsx',
    axes: {},
  },
};


function main() {
  const data = JSON.parse(fs.readFileSync(JSON_PATH, 'utf8'));
  const components = data.storybook?.components || {};
  const errors = [];

  for (const [name, cfg] of Object.entries(CHECK)) {
    const seed = components[name];
    if (!seed) {
      errors.push(`${name}: missing from seed JSON`);
      continue;
    }
    if (!fs.existsSync(path.join(ROOT, cfg.file))) {
      errors.push(`${name}: missing source ${cfg.file}`);
      continue;
    }
    for (const [axis, expected] of Object.entries(cfg.axes)) {
      const actual = seed.variants?.[axis] || [];
      const missing = expected.filter((v) => !actual.includes(v));
      const extra = actual.filter((v) => !expected.includes(v));
      if (missing.length || extra.length) {
        errors.push(
          `${name}.${axis}: react=[${expected}] seed=[${actual}] missing=${missing} extra=${extra}`,
        );
      }
    }
  }

  if (errors.length) {
    console.error('lint-variants failed:\n' + errors.map((e) => ` - ${e}`).join('\n'));
    process.exit(1);
  }
  console.log(`lint-variants: ok (${Object.keys(CHECK).length} components)`);
}

main();
