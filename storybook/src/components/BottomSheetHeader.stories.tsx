import type { Meta, StoryObj } from '@storybook/react';
import { BottomSheetHeader } from '@ds/react/draft';

const meta = {
  title: 'Draft/BottomSheetHeader',
  component: BottomSheetHeader,
  tags: ['autodocs'],
  args: { label: 'BottomSheetHeader' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof BottomSheetHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
