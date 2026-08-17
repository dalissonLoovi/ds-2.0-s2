import type { Meta, StoryObj } from '@storybook/react';
import { CalendarDay } from '@ds/react/draft';

const meta = {
  title: 'Draft/CalendarDay',
  component: CalendarDay,
  tags: ['autodocs'],
  args: { label: 'CalendarDay' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof CalendarDay>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
