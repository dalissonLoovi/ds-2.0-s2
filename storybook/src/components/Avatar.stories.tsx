import type { Meta, StoryObj } from '@storybook/react';
import { Avatar } from '@ds/react/draft';

const meta = {
  title: 'Draft/Avatar',
  component: Avatar,
  tags: ['autodocs'],
  args: { label: 'Avatar' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Avatar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
