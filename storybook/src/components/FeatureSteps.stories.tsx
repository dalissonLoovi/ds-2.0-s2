import type { Meta, StoryObj } from '@storybook/react';
import { FeatureSteps } from '@ds/react';

const meta = {
  title: 'Components/FeatureSteps',
  component: FeatureSteps,
  tags: ['autodocs'],
  args: { label: 'FeatureSteps' },
} satisfies Meta<typeof FeatureSteps>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
