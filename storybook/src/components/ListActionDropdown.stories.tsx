import type { Meta, StoryObj } from '@storybook/react';
import { ListActionDropdown } from '@ds/react/draft';

const meta = {
  title: 'Draft/ListActionDropdown',
  component: ListActionDropdown,
  tags: ['autodocs'],
  args: { label: 'ListActionDropdown' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof ListActionDropdown>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
