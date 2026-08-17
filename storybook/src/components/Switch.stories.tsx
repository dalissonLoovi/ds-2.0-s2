import type { Meta, StoryObj } from '@storybook/react';
import { Switch } from '@ds/react/draft';

const meta = {
  title: 'Draft/Switch',
  component: Switch,
  tags: ['autodocs'],
  args: { label: 'Switch' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Switch>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
