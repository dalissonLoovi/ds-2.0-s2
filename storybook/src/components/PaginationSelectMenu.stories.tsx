import type { Meta, StoryObj } from '@storybook/react';
import { PaginationSelectMenu } from '@ds/react/draft';

const meta = {
  title: 'Draft/PaginationSelectMenu',
  component: PaginationSelectMenu,
  tags: ['autodocs'],
  args: { label: 'PaginationSelectMenu' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof PaginationSelectMenu>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
