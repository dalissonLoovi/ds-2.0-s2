import type { Meta, StoryObj } from '@storybook/react';
import { SliderLeftRail } from '@ds/react/draft';

const meta = {
  title: 'Draft/SliderLeftRail',
  component: SliderLeftRail,
  tags: ['autodocs'],
  args: { label: 'SliderLeftRail' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof SliderLeftRail>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
