import type { Meta, StoryObj } from '@storybook/react';
import { NavigationDrawerItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/NavigationDrawerItem',
  component: NavigationDrawerItem,
  tags: ['autodocs'],
  args: { label: 'NavigationDrawerItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof NavigationDrawerItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
