import type { Meta, StoryObj } from '@storybook/react';
import { PaginationSelectInput } from '@ds/react/draft';

const meta = {
  title: 'Draft/PaginationSelectInput',
  component: PaginationSelectInput,
  tags: ['autodocs'],
  args: { label: 'PaginationSelectInput' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof PaginationSelectInput>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
