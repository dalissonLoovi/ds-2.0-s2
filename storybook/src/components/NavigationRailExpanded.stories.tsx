import type { Meta, StoryObj } from '@storybook/react';
import { NavigationRailExpanded } from '@ds/react/draft';

const meta = {
  title: 'Draft/NavigationRailExpanded',
  component: NavigationRailExpanded,
  tags: ['autodocs'],
  args: { label: 'NavigationRailExpanded' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof NavigationRailExpanded>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
