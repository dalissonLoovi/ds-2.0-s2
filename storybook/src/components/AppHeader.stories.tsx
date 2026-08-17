import type { Meta, StoryObj } from '@storybook/react';
import { AppHeader } from '@ds/react/draft';

const meta = {
  title: 'Draft/AppHeader',
  component: AppHeader,
  tags: ['autodocs'],
  args: { label: 'AppHeader' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof AppHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
