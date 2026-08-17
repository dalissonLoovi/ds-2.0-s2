import type { Meta, StoryObj } from '@storybook/react';
import { QuickAccessTile } from '@ds/react/draft';

const meta = {
  title: 'Draft/QuickAccessTile',
  component: QuickAccessTile,
  tags: ['autodocs'],
  args: { label: 'QuickAccessTile' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof QuickAccessTile>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
