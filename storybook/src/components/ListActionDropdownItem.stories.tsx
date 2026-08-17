import type { Meta, StoryObj } from '@storybook/react';
import { ListActionDropdownItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/ListActionDropdownItem',
  component: ListActionDropdownItem,
  tags: ['autodocs'],
  args: { label: 'ListActionDropdownItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof ListActionDropdownItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
