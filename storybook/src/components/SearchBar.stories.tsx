import type { Meta, StoryObj } from '@storybook/react';
import { SearchBar } from '@ds/react';

const meta = {
  title: 'Components/SearchBar',
  component: SearchBar,
  tags: ['autodocs'],
  args: { placeholder: 'Search' },
} satisfies Meta<typeof SearchBar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
