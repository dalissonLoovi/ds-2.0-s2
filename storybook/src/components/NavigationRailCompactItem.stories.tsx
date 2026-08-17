import type { Meta, StoryObj } from '@storybook/react';
import { NavigationRailCompactItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/NavigationRailCompactItem',
  component: NavigationRailCompactItem,
  tags: ['autodocs'],
  args: { label: 'NavigationRailCompactItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof NavigationRailCompactItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
