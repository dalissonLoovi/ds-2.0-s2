import type { Meta, StoryObj } from '@storybook/react';
import { SliderSkeletonItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/SliderSkeletonItem',
  component: SliderSkeletonItem,
  tags: ['autodocs'],
  args: { label: 'SliderSkeletonItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof SliderSkeletonItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
