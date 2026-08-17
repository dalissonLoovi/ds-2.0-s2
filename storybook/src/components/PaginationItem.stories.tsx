import type { Meta, StoryObj } from '@storybook/react';
import { PaginationItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/PaginationItem',
  component: PaginationItem,
  tags: ['autodocs'],
  args: { label: 'PaginationItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof PaginationItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
