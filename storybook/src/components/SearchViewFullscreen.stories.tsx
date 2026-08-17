import type { Meta, StoryObj } from '@storybook/react';
import { SearchViewFullscreen } from '@ds/react';

const meta = {
  title: 'Components/SearchViewFullscreen',
  component: SearchViewFullscreen,
  tags: ['autodocs'],
  args: { label: 'SearchViewFullscreen' },
} satisfies Meta<typeof SearchViewFullscreen>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
