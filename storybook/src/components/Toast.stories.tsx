import type { Meta, StoryObj } from '@storybook/react';
import { Toast } from '@ds/react';

const meta = {
  title: 'Components/Toast',
  component: Toast,
  tags: ['autodocs'],
  args: {
    status: 'success',
    message: 'Saved successfully',
    dismissible: true,
    showAction: false,
  },
} satisfies Meta<typeof Toast>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Success: Story = {};
export const WithAction: Story = { args: { showAction: true, actionLabel: 'Undo' } };
