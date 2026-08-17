/**
 * Generate CSF3 autodocs stories for scaffolded draft components.
 * Polished W0 stories are handwritten and import from @ds/react.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const COMP_DIR = path.join(ROOT, 'packages/react/src/components');
const OUT_DIR = path.join(ROOT, 'storybook/src/components');

const HANDWRITTEN = new Set([
  'Accordion',
  'Alert',
  'AppHeader',
  'Autocomplete',
  'Avatar',
  'AvatarGroup',
  'Badge',
  'Banner',
  'BottomSheet',
  'BottomSheetCheckItem',
  'BottomSheetHeader',
  'Breadcrumb',
  'BreadcrumbItem',
  'Button',
  'CardElevatedItem',
  'CardFilledItem',
  'CardHorizontal',
  'CardOutlinedItem',
  'CardStacked',
  'Carousel',
  'CarouselPaginationItem',
  'Checkbox',
  'ChipClickable',
  'ChipTag',
  'DatePickerSelect',
  'DatePickerSelectItem',
  'DashboardCardPrimary',
  'DashboardCardSecondary',
  'DividerHorizontal',
  'DividerVertical',
  'FeatureSteps',
  'FeatureStepsItem',
  'Input',
  'InputDatePicker',
  'InputNumber',
  'InputPassword',
  'InputSelect',
  'InputTextArea',
  'Link',
  'List',
  'ListActionDropdown',
  'ListActionDropdownItem',
  'ListItem',
  'ListItemImageThumbnail',
  'ListItemLeadingMonogram',
  'ListItemStateLayer',
  'ListItemVideoThumbnail',
  'LoadingSpinner',
  'Modal',
  'NavigationBar',
  'NavigationBarItem',
  'NavigationDrawer',
  'NavigationDrawerItem',
  'NavigationRailCompact',
  'NavigationRailCompactItem',
  'NavigationRailExpanded',
  'NavigationRailExpandedItem',
  'NavigationRailExpandedTree',
  'OrganizationHeader',
  'OfferProductCard',
  'Overlay',
  'Pagination',
  'PaginationItem',
  'ProgressBar',
  'QuickAccessTile',
  'RadioButton',
  'RadioButtonCard',
  'ReferralDiscountCard',
  'SearchBar',
  'SectionHeader',
  'SelectCountry',
  'Switch',
  'SystemHeader',
  'TabItem',
  'Table',
  'TableCell',
  'TableExpandCell',
  'TableMobile',
  'TableMobileCell',
  'TableRow',
  'TabsPrimary',
  'TabsSecondary',
  'TabsSegmented',
  'TextHeader',
  'Toast',
  'Tooltip',
  'TooltipRich',
  'UploadPhotos',
  'VehicleConfirmCard',
  'VehicleSummaryCard',
  'VerificationCodeInput',
  'VerificationCodeInputItem',
]);

function story(name) {
  return `import type { Meta, StoryObj } from '@storybook/react';
import { ${name} } from '@ds/react/draft';

const meta = {
  title: 'Draft/${name}',
  component: ${name},
  tags: ['autodocs'],
  args: { label: '${name}' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from \`@ds/react/draft\`.',
      },
    },
  },
} satisfies Meta<typeof ${name}>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
`;
}

function main() {
  const names = fs
    .readdirSync(COMP_DIR)
    .filter((n) => fs.statSync(path.join(COMP_DIR, n)).isDirectory())
    .sort();
  let count = 0;
  for (const name of names) {
    if (HANDWRITTEN.has(name)) continue;
    if (name.startsWith('_')) continue;
    fs.writeFileSync(path.join(OUT_DIR, `${name}.stories.tsx`), story(name));
    count += 1;
  }
  console.log(`Wrote ${count} draft story files`);
}

main();
