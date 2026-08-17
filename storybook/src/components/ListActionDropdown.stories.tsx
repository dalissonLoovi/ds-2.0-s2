import type { Meta, StoryObj } from '@storybook/react';
import { ListActionDropdown } from '@ds/react';

const meta = {
  title: 'Components/ListActionDropdown',
  component: ListActionDropdown,
  tags: ['autodocs'],
  args: { label: 'ListActionDropdown' },
} satisfies Meta<typeof ListActionDropdown>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
