import type { Meta, StoryObj } from '@storybook/react';
import { DividerHorizontal } from '@ds/react';

const meta = {
  title: 'Components/DividerHorizontal',
  component: DividerHorizontal,
  tags: ['autodocs'],
  args: { label: 'DividerHorizontal' },
} satisfies Meta<typeof DividerHorizontal>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
