import type { Meta, StoryObj } from '@storybook/react';
import { Alert } from '@ds/react';

const meta = {
  title: 'Components/Alert',
  component: Alert,
  tags: ['autodocs'],
  args: {
    status: 'info',
    appearance: 'default',
    title: 'Title',
    description: 'Description',
    showDescription: true,
    showAction: true,
    actionLabel: 'Action',
  },
} satisfies Meta<typeof Alert>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Info: Story = {};
export const Success: Story = { args: { status: 'success' } };
export const Danger: Story = { args: { status: 'danger' } };
export const Inverse: Story = { args: { appearance: 'inverse' } };
