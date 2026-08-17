import type { Meta, StoryObj } from '@storybook/react';
import { TooltipRich, Button } from '@ds/react';

const meta = {
  title: 'Components/TooltipRich',
  component: TooltipRich,
  tags: ['autodocs'],
  args: { title: 'Title', description: 'More detail', open: true },
  render: (args) => (
    <TooltipRich {...args}>
      <Button label="Open tip" />
    </TooltipRich>
  ),
} satisfies Meta<typeof TooltipRich>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
