import type { Meta, StoryObj } from '@storybook/react';
import { AppHeader } from '@ds/react';

const meta = {
  title: 'Components/AppHeader',
  component: AppHeader,
  tags: ['autodocs'],
  args: { label: 'AppHeader' },
} satisfies Meta<typeof AppHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
