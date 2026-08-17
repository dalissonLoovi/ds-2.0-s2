import type { Meta, StoryObj } from '@storybook/react';
import { SystemHeader } from '@ds/react';

const meta = {
  title: 'Components/SystemHeader',
  component: SystemHeader,
  tags: ['autodocs'],
  args: { label: 'SystemHeader' },
} satisfies Meta<typeof SystemHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
