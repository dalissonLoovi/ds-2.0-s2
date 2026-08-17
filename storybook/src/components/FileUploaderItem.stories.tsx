import type { Meta, StoryObj } from '@storybook/react';
import { FileUploaderItem } from '@ds/react';

const meta = {
  title: 'Components/FileUploaderItem',
  component: FileUploaderItem,
  tags: ['autodocs'],
  args: { label: 'FileUploaderItem' },
} satisfies Meta<typeof FileUploaderItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
