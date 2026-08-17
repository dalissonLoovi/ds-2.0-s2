import type { Meta, StoryObj } from '@storybook/react';
import { Carousel } from '@ds/react';

const meta = {
  title: 'Components/Carousel',
  component: Carousel,
  tags: ['autodocs'],
  args: { label: 'Carousel' },
} satisfies Meta<typeof Carousel>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
