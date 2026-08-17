import type { Meta, StoryObj } from '@storybook/react';
import { ListItemVideoThumbnail } from '@ds/react/draft';

const meta = {
  title: 'Draft/ListItemVideoThumbnail',
  component: ListItemVideoThumbnail,
  tags: ['autodocs'],
  args: { label: 'ListItemVideoThumbnail' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof ListItemVideoThumbnail>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
