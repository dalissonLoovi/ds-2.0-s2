import type { Meta, StoryObj } from '@storybook/react';
import { DividerVertical } from '@ds/react/draft';

const meta = {
  title: 'Draft/DividerVertical',
  component: DividerVertical,
  tags: ['autodocs'],
  args: { label: 'DividerVertical' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof DividerVertical>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
