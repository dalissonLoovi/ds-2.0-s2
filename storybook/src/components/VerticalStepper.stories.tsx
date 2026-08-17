import type { Meta, StoryObj } from '@storybook/react';
import { VerticalStepper } from '@ds/react/draft';

const meta = {
  title: 'Draft/VerticalStepper',
  component: VerticalStepper,
  tags: ['autodocs'],
  args: { label: 'VerticalStepper' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof VerticalStepper>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
