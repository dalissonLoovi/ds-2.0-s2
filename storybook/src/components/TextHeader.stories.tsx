import type { Meta, StoryObj } from '@storybook/react';
import { TextHeader } from '@ds/react';

const meta = {
  title: 'Components/TextHeader',
  component: TextHeader,
  tags: ['autodocs'],
  args: { label: 'TextHeader' },
} satisfies Meta<typeof TextHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
