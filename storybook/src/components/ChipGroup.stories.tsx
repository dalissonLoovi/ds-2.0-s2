import type { Meta, StoryObj } from '@storybook/react';
import { ChipGroup } from '@ds/react/draft';

const meta = {
  title: 'Draft/ChipGroup',
  component: ChipGroup,
  tags: ['autodocs'],
  args: { label: 'ChipGroup' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof ChipGroup>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
