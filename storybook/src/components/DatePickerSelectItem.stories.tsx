import type { Meta, StoryObj } from '@storybook/react';
import { DatePickerSelectItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/DatePickerSelectItem',
  component: DatePickerSelectItem,
  tags: ['autodocs'],
  args: { label: 'DatePickerSelectItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof DatePickerSelectItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
