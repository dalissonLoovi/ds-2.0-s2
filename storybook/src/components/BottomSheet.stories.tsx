import type { Meta, StoryObj } from '@storybook/react';
import { BottomSheet } from '@ds/react/draft';

const meta = {
  title: 'Draft/BottomSheet',
  component: BottomSheet,
  tags: ['autodocs'],
  args: { label: 'BottomSheet' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof BottomSheet>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
