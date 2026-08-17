import type { Meta, StoryObj } from '@storybook/react';
import { StepperPrimary } from '@ds/react/draft';

const meta = {
  title: 'Draft/StepperPrimary',
  component: StepperPrimary,
  tags: ['autodocs'],
  args: { label: 'StepperPrimary' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof StepperPrimary>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
