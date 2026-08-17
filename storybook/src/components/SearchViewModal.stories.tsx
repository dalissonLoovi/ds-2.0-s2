import type { Meta, StoryObj } from '@storybook/react';
import { SearchViewModal } from '@ds/react';

const meta = {
  title: 'Components/SearchViewModal',
  component: SearchViewModal,
  tags: ['autodocs'],
  args: { label: 'SearchViewModal' },
} satisfies Meta<typeof SearchViewModal>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
