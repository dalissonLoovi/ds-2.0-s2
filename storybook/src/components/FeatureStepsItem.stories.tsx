import type { Meta, StoryObj } from '@storybook/react';
import { FeatureStepsItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/FeatureStepsItem',
  component: FeatureStepsItem,
  tags: ['autodocs'],
  args: { label: 'FeatureStepsItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof FeatureStepsItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
