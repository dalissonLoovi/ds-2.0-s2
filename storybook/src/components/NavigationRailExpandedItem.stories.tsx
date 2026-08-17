import type { Meta, StoryObj } from '@storybook/react';
import { NavigationRailExpandedItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/NavigationRailExpandedItem',
  component: NavigationRailExpandedItem,
  tags: ['autodocs'],
  args: { label: 'NavigationRailExpandedItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof NavigationRailExpandedItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
