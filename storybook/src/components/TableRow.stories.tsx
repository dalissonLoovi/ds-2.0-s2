import type { Meta, StoryObj } from '@storybook/react';
import { TableRow } from '@ds/react/draft';

const meta = {
  title: 'Draft/TableRow',
  component: TableRow,
  tags: ['autodocs'],
  args: { label: 'TableRow' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof TableRow>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
