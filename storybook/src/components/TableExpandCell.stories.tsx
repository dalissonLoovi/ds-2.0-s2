import type { Meta, StoryObj } from '@storybook/react';
import { TableExpandCell } from '@ds/react/draft';

const meta = {
  title: 'Draft/TableExpandCell',
  component: TableExpandCell,
  tags: ['autodocs'],
  args: { label: 'TableExpandCell' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof TableExpandCell>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
