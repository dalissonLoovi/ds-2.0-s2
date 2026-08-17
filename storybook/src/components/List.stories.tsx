import type { Meta, StoryObj } from '@storybook/react';
import { List } from '@ds/react/draft';

const meta = {
  title: 'Draft/List',
  component: List,
  tags: ['autodocs'],
  args: { label: 'List' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof List>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
