import type { Meta, StoryObj } from '@storybook/react';
import { StepProgressIndicator } from '@ds/react/draft';

const meta = {
  title: 'Draft/StepProgressIndicator',
  component: StepProgressIndicator,
  tags: ['autodocs'],
  args: { label: 'StepProgressIndicator' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof StepProgressIndicator>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
