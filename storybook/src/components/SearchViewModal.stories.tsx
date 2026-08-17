import type { Meta, StoryObj } from '@storybook/react';
import { SearchViewModal } from '@ds/react/draft';

const meta = {
  title: 'Draft/SearchViewModal',
  component: SearchViewModal,
  tags: ['autodocs'],
  args: { label: 'SearchViewModal' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof SearchViewModal>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
