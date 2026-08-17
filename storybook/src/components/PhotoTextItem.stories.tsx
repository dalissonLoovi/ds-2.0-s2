import type { Meta, StoryObj } from '@storybook/react';
import { PhotoTextItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/PhotoTextItem',
  component: PhotoTextItem,
  tags: ['autodocs'],
  args: { label: 'PhotoTextItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof PhotoTextItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
