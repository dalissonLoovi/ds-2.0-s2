import type { Meta, StoryObj } from '@storybook/react';
import { Calendar } from '@ds/react/draft';

const meta = {
  title: 'Draft/Calendar',
  component: Calendar,
  tags: ['autodocs'],
  args: { label: 'Calendar' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Calendar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
