import type { Meta, StoryObj } from '@storybook/react';
import { FileUploaderList } from '@ds/react';

const meta = {
  title: 'Components/FileUploaderList',
  component: FileUploaderList,
  tags: ['autodocs'],
  args: {},
} satisfies Meta<typeof FileUploaderList>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
