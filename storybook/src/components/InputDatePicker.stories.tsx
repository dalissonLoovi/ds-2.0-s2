import type { Meta, StoryObj } from '@storybook/react';
import { InputDatePicker } from '@ds/react/draft';

const meta = {
  title: 'Draft/InputDatePicker',
  component: InputDatePicker,
  tags: ['autodocs'],
  args: { label: 'InputDatePicker' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof InputDatePicker>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
