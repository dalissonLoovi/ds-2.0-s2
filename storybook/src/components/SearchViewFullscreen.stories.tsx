import type { Meta, StoryObj } from '@storybook/react';
import { SearchViewFullscreen } from '@ds/react/draft';

const meta = {
  title: 'Draft/SearchViewFullscreen',
  component: SearchViewFullscreen,
  tags: ['autodocs'],
  args: { label: 'SearchViewFullscreen' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof SearchViewFullscreen>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
