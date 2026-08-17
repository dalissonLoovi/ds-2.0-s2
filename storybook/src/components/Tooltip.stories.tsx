import type { Meta, StoryObj } from '@storybook/react';
import { Tooltip, Button } from '@ds/react';

const meta = {
  title: 'Components/Tooltip',
  component: Tooltip,
  tags: ['autodocs'],
  args: { description: 'Helpful tip', open: true },
  render: (args) => (
    <Tooltip {...args}>
      <Button label="Hover me" />
    </Tooltip>
  ),
} satisfies Meta<typeof Tooltip>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
