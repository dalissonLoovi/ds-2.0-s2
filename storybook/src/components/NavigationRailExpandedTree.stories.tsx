import type { Meta, StoryObj } from '@storybook/react';
import { NavigationRailExpandedTree } from '@ds/react/draft';

const meta = {
  title: 'Draft/NavigationRailExpandedTree',
  component: NavigationRailExpandedTree,
  tags: ['autodocs'],
  args: { label: 'NavigationRailExpandedTree' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof NavigationRailExpandedTree>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
