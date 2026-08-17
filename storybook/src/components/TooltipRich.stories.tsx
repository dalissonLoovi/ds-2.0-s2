import type { Meta, StoryObj } from '@storybook/react';
import { TooltipRich } from '@ds/react';

const meta = {
  title: 'Components/TooltipRich',
  component: TooltipRich,
  tags: ['autodocs'],
  args: { label: 'TooltipRich' },
} satisfies Meta<typeof TooltipRich>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
