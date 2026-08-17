import type { Meta, StoryObj } from '@storybook/react';
import { ListItemStateLayer } from '@ds/react/draft';

const meta = {
  title: 'Draft/ListItemStateLayer',
  component: ListItemStateLayer,
  tags: ['autodocs'],
  args: { label: 'ListItemStateLayer' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof ListItemStateLayer>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
