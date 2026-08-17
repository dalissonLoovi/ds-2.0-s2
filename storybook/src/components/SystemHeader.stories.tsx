import type { Meta, StoryObj } from '@storybook/react';
import { SystemHeader } from '@ds/react/draft';

const meta = {
  title: 'Draft/SystemHeader',
  component: SystemHeader,
  tags: ['autodocs'],
  args: { label: 'SystemHeader' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof SystemHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
