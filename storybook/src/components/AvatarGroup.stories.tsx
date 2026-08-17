import type { Meta, StoryObj } from '@storybook/react';
import { AvatarGroup } from '@ds/react';

const meta = {
  title: 'Components/AvatarGroup',
  component: AvatarGroup,
  tags: ['autodocs'],
  args: { size: 'md' },
} satisfies Meta<typeof AvatarGroup>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
