import type { Meta, StoryObj } from '@storybook/react';
import { DividerHorizontal } from '@ds/react/draft';

const meta = {
  title: 'Draft/DividerHorizontal',
  component: DividerHorizontal,
  tags: ['autodocs'],
  args: { label: 'DividerHorizontal' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof DividerHorizontal>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
