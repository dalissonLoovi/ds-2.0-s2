import type { Meta, StoryObj } from '@storybook/react';
import { ModalCheckItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/ModalCheckItem',
  component: ModalCheckItem,
  tags: ['autodocs'],
  args: { label: 'ModalCheckItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof ModalCheckItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
