import type { Meta, StoryObj } from '@storybook/react';
import { StepProgressSegment } from '@ds/react';

const meta = {
  title: 'Components/StepProgressSegment',
  component: StepProgressSegment,
  tags: ['autodocs'],
  args: { status: 'completed' },
} satisfies Meta<typeof StepProgressSegment>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
