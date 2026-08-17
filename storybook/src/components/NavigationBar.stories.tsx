import type { Meta, StoryObj } from '@storybook/react';
import { NavigationBar } from '@ds/react/draft';

const meta = {
  title: 'Draft/NavigationBar',
  component: NavigationBar,
  tags: ['autodocs'],
  args: { label: 'NavigationBar' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof NavigationBar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
