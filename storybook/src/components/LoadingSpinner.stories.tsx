import type { Meta, StoryObj } from '@storybook/react';
import { LoadingSpinner } from '@ds/react/draft';

const meta = {
  title: 'Draft/LoadingSpinner',
  component: LoadingSpinner,
  tags: ['autodocs'],
  args: { label: 'LoadingSpinner' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof LoadingSpinner>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
