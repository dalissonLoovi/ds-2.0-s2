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
        <Button variant="text" label="Cancelar" />
        <Button label="Confirmar" />
      </>
    ),
  },
};
export const Mobile: Story = { args: { platform: 'mobile' } };
/** showFooter — web: horizontal, right-aligned, size=lg. */
export const WithFooter: Story = {
  args: { showFooter: true, primaryActionLabel: 'Confirmar', secondaryActionLabel: 'Cancelar' },
};
/** showFooter — mobile: vertical, full width, primary on top, size=md. */
export const WithFooterMobile: Story = {
  args: {
    platform: 'mobile',
    showFooter: true,
    primaryActionLabel: 'Confirmar',
    secondaryActionLabel: 'Cancelar',
  },
};
