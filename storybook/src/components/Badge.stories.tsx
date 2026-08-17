import type { Meta, StoryObj } from '@storybook/react';
import { Badge } from '@ds/react/draft';

const meta = {
  title: 'Draft/Badge',
  component: Badge,
  tags: ['autodocs'],
  args: { label: 'Badge' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Badge>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
