import type { Meta, StoryObj } from '@storybook/react';
import { Autocomplete } from '@ds/react';

const meta = {
  title: 'Components/Autocomplete',
  component: Autocomplete,
  tags: ['autodocs'],
  args: { label: 'Autocomplete' },
} satisfies Meta<typeof Autocomplete>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
