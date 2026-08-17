import type { Meta, StoryObj } from '@storybook/react';
import { AvatarGroup } from '@ds/react/draft';

const meta = {
  title: 'Draft/AvatarGroup',
  component: AvatarGroup,
  tags: ['autodocs'],
  args: { label: 'AvatarGroup' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof AvatarGroup>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
