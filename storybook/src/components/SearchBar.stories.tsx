import type { Meta, StoryObj } from '@storybook/react';
import { SearchBar } from '@ds/react/draft';

const meta = {
  title: 'Draft/SearchBar',
  component: SearchBar,
  tags: ['autodocs'],
  args: { label: 'SearchBar' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof SearchBar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
