import type { Meta, StoryObj } from '@storybook/react';
import { Tooltip } from '@ds/react/draft';

const meta = {
  title: 'Draft/Tooltip',
  component: Tooltip,
  tags: ['autodocs'],
  args: { label: 'Tooltip' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Tooltip>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
