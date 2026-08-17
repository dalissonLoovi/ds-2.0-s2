import type { Meta, StoryObj } from '@storybook/react';
import { UploadPhotos } from '@ds/react';

const meta = {
  title: 'Components/UploadPhotos',
  component: UploadPhotos,
  tags: ['autodocs'],
  args: { label: 'UploadPhotos' },
} satisfies Meta<typeof UploadPhotos>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
