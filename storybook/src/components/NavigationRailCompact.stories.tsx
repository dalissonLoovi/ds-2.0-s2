import type { Meta, StoryObj } from '@storybook/react';
import { NavigationRailCompact } from '@ds/react/draft';

const meta = {
  title: 'Draft/NavigationRailCompact',
  component: NavigationRailCompact,
  tags: ['autodocs'],
  args: { label: 'NavigationRailCompact' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof NavigationRailCompact>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
