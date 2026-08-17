import type { Meta, StoryObj } from '@storybook/react';
import { NavigationBar } from '@ds/react';

const meta = {
  title: 'Components/NavigationBar',
  component: NavigationBar,
  tags: ['autodocs'],
  args: { itemCount: '4', layout: 'flush' },
} satisfies Meta<typeof NavigationBar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
