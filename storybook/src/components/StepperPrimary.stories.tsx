import type { Meta, StoryObj } from '@storybook/react';
import { StepperPrimary } from '@ds/react';

const meta = {
  title: 'Components/StepperPrimary',
  component: StepperPrimary,
  tags: ['autodocs'],
  args: { status: 'current', label: 'Step', trail: 'both', trailState: 'left' },
} satisfies Meta<typeof StepperPrimary>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
