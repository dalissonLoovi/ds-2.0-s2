import type { Meta, StoryObj } from '@storybook/react';
import { CardHorizontal } from '@ds/react';

const meta = {
  title: 'Components/CardHorizontal',
  component: CardHorizontal,
  tags: ['autodocs'],
  args: { cardStyle: 'outlined', layout: 'media-and-text' },
} satisfies Meta<typeof CardHorizontal>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
