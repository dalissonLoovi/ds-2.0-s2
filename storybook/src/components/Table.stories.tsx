import type { Meta, StoryObj } from '@storybook/react';
import { Table } from '@ds/react/draft';

const meta = {
  title: 'Draft/Table',
  component: Table,
  tags: ['autodocs'],
  args: { label: 'Table' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Table>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
