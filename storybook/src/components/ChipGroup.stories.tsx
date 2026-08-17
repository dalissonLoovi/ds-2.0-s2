import type { Meta, StoryObj } from '@storybook/react';
import { ChipGroup } from '@ds/react';

const meta = {
  title: 'Components/ChipGroup',
  component: ChipGroup,
  tags: ['autodocs'],
  args: { type: 'filter', layout: 'single-row-scrollable' },
} satisfies Meta<typeof ChipGroup>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
