import type { Meta, StoryObj } from '@storybook/react';
import { FileUploaderDropzoneItem } from '@ds/react';

const meta = {
  title: 'Components/FileUploaderDropzoneItem',
  component: FileUploaderDropzoneItem,
  tags: ['autodocs'],
  args: { helperText: 'Arraste arquivos ou clique para selecionar' },
} satisfies Meta<typeof FileUploaderDropzoneItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
