import type { Meta, StoryObj } from '@storybook/react';
import { Modal, Button } from '@ds/react';

const meta = {
  title: 'Components/Modal',
  component: Modal,
  tags: ['autodocs'],
  args: {
    open: true,
    platform: 'web',
    title: 'Title',
    showCloseAction: true,
    children: 'Modal body content',
  },
} satisfies Meta<typeof Modal>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Web: Story = {
  args: {
    footer: (
      <>
        <Button variant="text" label="Cancel" />
        <Button label="Confirm" />
      </>
    ),
  },
};
export const Mobile: Story = { args: { platform: 'mobile' } };
