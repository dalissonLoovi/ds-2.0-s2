import type { Meta, StoryObj } from '@storybook/react';
import { FeatureSteps } from '@ds/react/draft';

const meta = {
  title: 'Draft/FeatureSteps',
  component: FeatureSteps,
  tags: ['autodocs'],
  args: { label: 'FeatureSteps' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof FeatureSteps>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
