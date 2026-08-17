import type { Meta, StoryObj } from '@storybook/react';
import { BottomSheetCheckItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/BottomSheetCheckItem',
  component: BottomSheetCheckItem,
  tags: ['autodocs'],
  args: { label: 'BottomSheetCheckItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof BottomSheetCheckItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
