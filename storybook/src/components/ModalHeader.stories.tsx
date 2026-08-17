import type { Meta, StoryObj } from '@storybook/react';
import { ModalHeader } from '@ds/react';

const meta = {
  title: 'Components/ModalHeader',
  component: ModalHeader,
  tags: ['autodocs'],
  args: { label: 'ModalHeader' },
} satisfies Meta<typeof ModalHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
