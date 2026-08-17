import type { Meta, StoryObj } from '@storybook/react';
import { ListItemImageThumbnail } from '@ds/react';

const meta = {
  title: 'Components/ListItemImageThumbnail',
  component: ListItemImageThumbnail,
  tags: ['autodocs'],
  args: { label: 'ListItemImageThumbnail' },
} satisfies Meta<typeof ListItemImageThumbnail>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
