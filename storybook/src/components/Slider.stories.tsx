import type { Meta, StoryObj } from '@storybook/react';
import { Slider } from '@ds/react/draft';

const meta = {
  title: 'Draft/Slider',
  component: Slider,
  tags: ['autodocs'],
  args: { label: 'Slider' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Slider>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
