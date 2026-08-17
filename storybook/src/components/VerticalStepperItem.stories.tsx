import type { Meta, StoryObj } from '@storybook/react';
import { VerticalStepperItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/VerticalStepperItem',
  component: VerticalStepperItem,
  tags: ['autodocs'],
  args: { label: 'VerticalStepperItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof VerticalStepperItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
