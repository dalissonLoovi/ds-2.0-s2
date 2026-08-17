import type { Meta, StoryObj } from '@storybook/react';
import { CardHorizontal } from '@ds/react/draft';

const meta = {
  title: 'Draft/CardHorizontal',
  component: CardHorizontal,
  tags: ['autodocs'],
  args: { label: 'CardHorizontal' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof CardHorizontal>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
