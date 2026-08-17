import type { Meta, StoryObj } from '@storybook/react';
import { NavigationDrawer } from '@ds/react/draft';

const meta = {
  title: 'Draft/NavigationDrawer',
  component: NavigationDrawer,
  tags: ['autodocs'],
  args: { label: 'NavigationDrawer' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof NavigationDrawer>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
