import type { Meta, StoryObj } from '@storybook/react';
import { DividerVertical } from '@ds/react';

const meta = {
  title: 'Components/DividerVertical',
  component: DividerVertical,
  tags: ['autodocs'],
  args: { variant: 'full-width' },
} satisfies Meta<typeof DividerVertical>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
