import type { Meta, StoryObj } from '@storybook/react';
import { RadioButtonCard } from '@ds/react/draft';

const meta = {
  title: 'Draft/RadioButtonCard',
  component: RadioButtonCard,
  tags: ['autodocs'],
  args: { label: 'RadioButtonCard' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof RadioButtonCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
