import type { Meta, StoryObj } from '@storybook/react';
import { Overlay } from '@ds/react';

const meta = {
  title: 'Components/Overlay',
  component: Overlay,
  tags: ['autodocs'],
  args: { label: 'Overlay' },
} satisfies Meta<typeof Overlay>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
