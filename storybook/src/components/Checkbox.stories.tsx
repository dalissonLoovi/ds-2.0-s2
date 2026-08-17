import type { Meta, StoryObj } from '@storybook/react';
import { Checkbox } from '@ds/react/draft';

const meta = {
  title: 'Draft/Checkbox',
  component: Checkbox,
  tags: ['autodocs'],
  args: { label: 'Checkbox' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Checkbox>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
