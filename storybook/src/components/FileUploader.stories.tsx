import type { Meta, StoryObj } from '@storybook/react';
import { FileUploader } from '@ds/react';

const meta = {
  title: 'Components/FileUploader',
  component: FileUploader,
  tags: ['autodocs'],
  args: { label: 'FileUploader' },
} satisfies Meta<typeof FileUploader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
