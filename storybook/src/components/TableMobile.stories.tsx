import type { Meta, StoryObj } from '@storybook/react';
import { TableMobile } from '@ds/react/draft';

const meta = {
  title: 'Draft/TableMobile',
  component: TableMobile,
  tags: ['autodocs'],
  args: { label: 'TableMobile' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof TableMobile>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
