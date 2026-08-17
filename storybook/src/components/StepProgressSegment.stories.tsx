import type { Meta, StoryObj } from '@storybook/react';
import { StepProgressSegment } from '@ds/react/draft';

const meta = {
  title: 'Draft/StepProgressSegment',
  component: StepProgressSegment,
  tags: ['autodocs'],
  args: { label: 'StepProgressSegment' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof StepProgressSegment>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
