import type { Meta, StoryObj } from '@storybook/react';
import { CarouselPaginationItem } from '@ds/react';

const meta = {
  title: 'Components/CarouselPaginationItem',
  component: CarouselPaginationItem,
  tags: ['autodocs'],
  args: { label: 'CarouselPaginationItem' },
} satisfies Meta<typeof CarouselPaginationItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
