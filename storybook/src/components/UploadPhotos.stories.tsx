import type { Meta, StoryObj } from '@storybook/react';
import { UploadPhotos } from '@ds/react';

const meta = {
  title: 'Components/UploadPhotos',
  component: UploadPhotos,
  tags: ['autodocs'],
  args: { status: 'pending', label: 'Foto do documento' },
} satisfies Meta<typeof UploadPhotos>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
