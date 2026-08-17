import type { Meta, StoryObj } from '@storybook/react';
import { Pagination } from '@ds/react/draft';

const meta = {
  title: 'Draft/Pagination',
  component: Pagination,
  tags: ['autodocs'],
  args: { label: 'Pagination' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Pagination>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
