import type { Meta, StoryObj } from '@storybook/react';
import { FeatureStepsItem } from '@ds/react';

const meta = {
  title: 'Components/FeatureStepsItem',
  component: FeatureStepsItem,
  tags: ['autodocs'],
  args: { label: 'FeatureStepsItem' },
} satisfies Meta<typeof FeatureStepsItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
