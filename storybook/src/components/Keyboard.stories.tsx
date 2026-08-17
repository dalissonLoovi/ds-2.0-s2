import type { Meta, StoryObj } from '@storybook/react';
import { Keyboard } from '@ds/react/draft';

const meta = {
  title: 'Draft/Keyboard',
  component: Keyboard,
  tags: ['autodocs'],
  args: { label: 'Keyboard' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Keyboard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
