import type { Meta, StoryObj } from '@storybook/react';
import { ProgressBar } from '@ds/react/draft';

const meta = {
  title: 'Draft/ProgressBar',
  component: ProgressBar,
  tags: ['autodocs'],
  args: { label: 'ProgressBar' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof ProgressBar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
