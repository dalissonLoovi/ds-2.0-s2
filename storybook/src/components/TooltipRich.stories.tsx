import type { Meta, StoryObj } from '@storybook/react';
import { TooltipRich } from '@ds/react/draft';

const meta = {
  title: 'Draft/TooltipRich',
  component: TooltipRich,
  tags: ['autodocs'],
  args: { label: 'TooltipRich' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof TooltipRich>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
