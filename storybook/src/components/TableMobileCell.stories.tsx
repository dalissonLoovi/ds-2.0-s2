import type { Meta, StoryObj } from '@storybook/react';
import { TableMobileCell } from '@ds/react/draft';

const meta = {
  title: 'Draft/TableMobileCell',
  component: TableMobileCell,
  tags: ['autodocs'],
  args: { label: 'TableMobileCell' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof TableMobileCell>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
