import type { Meta, StoryObj } from '@storybook/react';
import { Checkbox } from '@ds/react';

const meta = {
  title: 'Components/Checkbox',
  component: Checkbox,
  tags: ['autodocs'],
  args: { label: 'Accept', showDescription: true, description: 'Optional detail' },
} satisfies Meta<typeof Checkbox>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
