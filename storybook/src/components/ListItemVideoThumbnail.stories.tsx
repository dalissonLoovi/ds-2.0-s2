import type { Meta, StoryObj } from '@storybook/react';
import { ListItemVideoThumbnail } from '@ds/react';

const meta = {
  title: 'Components/ListItemVideoThumbnail',
  component: ListItemVideoThumbnail,
  tags: ['autodocs'],
  args: {},
} satisfies Meta<typeof ListItemVideoThumbnail>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
