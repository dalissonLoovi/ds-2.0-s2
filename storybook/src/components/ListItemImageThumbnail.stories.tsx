import type { Meta, StoryObj } from '@storybook/react';
import { ListItemImageThumbnail } from '@ds/react/draft';

const meta = {
  title: 'Draft/ListItemImageThumbnail',
  component: ListItemImageThumbnail,
  tags: ['autodocs'],
  args: { label: 'ListItemImageThumbnail' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof ListItemImageThumbnail>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
