import type { Meta, StoryObj } from '@storybook/react';
import { SliderItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/SliderItem',
  component: SliderItem,
  tags: ['autodocs'],
  args: { label: 'SliderItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof SliderItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
