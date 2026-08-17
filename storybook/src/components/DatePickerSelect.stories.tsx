import type { Meta, StoryObj } from '@storybook/react';
import { DatePickerSelect } from '@ds/react/draft';

const meta = {
  title: 'Draft/DatePickerSelect',
  component: DatePickerSelect,
  tags: ['autodocs'],
  args: { label: 'DatePickerSelect' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof DatePickerSelect>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
