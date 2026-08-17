import type { Meta, StoryObj } from '@storybook/react';
import { StepProgressIndicator } from '@ds/react';

const meta = {
  title: 'Components/StepProgressIndicator',
  component: StepProgressIndicator,
  tags: ['autodocs'],
  args: { stepCount: '3', currentStep: '1' },
} satisfies Meta<typeof StepProgressIndicator>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
