import type { Meta, StoryObj } from '@storybook/react';
import { ListActionDropdownItem } from '@ds/react';

const meta = {
  title: 'Components/ListActionDropdownItem',
  component: ListActionDropdownItem,
  tags: ['autodocs'],
  args: { label: 'Edit' },
} satisfies Meta<typeof ListActionDropdownItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
