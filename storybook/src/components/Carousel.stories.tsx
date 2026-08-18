import type { Meta, StoryObj } from '@storybook/react';
import { Carousel } from '@ds/react';

const meta = {
  title: 'Components/Carousel',
  component: Carousel,
  tags: ['autodocs'],
  args: { showPaginationItem: true, itemCount: '4' },
} satisfies Meta<typeof Carousel>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
