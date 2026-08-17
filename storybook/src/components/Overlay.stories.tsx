import type { Meta, StoryObj } from '@storybook/react';
import { Overlay } from '@ds/react';

const meta = {
  title: 'Components/Overlay',
  component: Overlay,
  tags: ['autodocs'],
  args: { type: 'modal', platform: 'web', open: true },
  parameters: { layout: 'fullscreen' },
  render: (args) => (
    <Overlay {...args}>
      <div style={{ padding: 24, background: 'white', borderRadius: 12 }}>Slot content</div>
    </Overlay>
  ),
} satisfies Meta<typeof Overlay>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
