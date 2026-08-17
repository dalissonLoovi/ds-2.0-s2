import type { Meta, StoryObj } from '@storybook/react';
import { SliderRail } from '@ds/react/draft';

const meta = {
  title: 'Draft/SliderRail',
  component: SliderRail,
  tags: ['autodocs'],
  args: { label: 'SliderRail' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof SliderRail>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
