import type { Meta, StoryObj } from '@storybook/react';
import { CardStacked } from '@ds/react';

const meta = {
  title: 'Components/CardStacked',
  component: CardStacked,
  tags: ['autodocs'],
  args: { cardStyle: 'outlined', layout: 'media-and-text' },
} satisfies Meta<typeof CardStacked>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
