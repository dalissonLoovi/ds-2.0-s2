import type { Meta, StoryObj } from '@storybook/react';
import { ImageItem } from '@ds/react';

const meta = {
  title: 'Components/ImageItem',
  component: ImageItem,
  tags: ['autodocs'],
  args: { label: 'ImageItem' },
} satisfies Meta<typeof ImageItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
