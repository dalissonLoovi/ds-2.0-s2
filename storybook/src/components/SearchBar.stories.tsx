import type { Meta, StoryObj } from '@storybook/react';
import { SearchBar } from '@ds/react';

const meta = {
  title: 'Components/SearchBar',
  component: SearchBar,
  tags: ['autodocs'],
  args: { label: 'SearchBar' },
} satisfies Meta<typeof SearchBar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
