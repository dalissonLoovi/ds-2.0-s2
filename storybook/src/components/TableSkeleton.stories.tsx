import type { Meta, StoryObj } from '@storybook/react';
import { TableSkeleton } from '@ds/react/draft';

const meta = {
  title: 'Draft/TableSkeleton',
  component: TableSkeleton,
  tags: ['autodocs'],
  args: { label: 'TableSkeleton' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof TableSkeleton>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
