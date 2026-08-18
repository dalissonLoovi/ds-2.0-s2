import type { Meta, StoryObj } from '@storybook/react';
import { ModalCheckItem } from '@ds/react';

const meta = {
  title: 'Components/ModalCheckItem',
  component: ModalCheckItem,
  tags: ['autodocs'],
  args: {},
} satisfies Meta<typeof ModalCheckItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
