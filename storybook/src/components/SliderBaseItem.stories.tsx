import type { Meta, StoryObj } from '@storybook/react';
import { SliderBaseItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/SliderBaseItem',
  component: SliderBaseItem,
  tags: ['autodocs'],
  args: { label: 'SliderBaseItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof SliderBaseItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
