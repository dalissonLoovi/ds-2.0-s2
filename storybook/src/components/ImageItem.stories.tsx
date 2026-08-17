import type { Meta, StoryObj } from '@storybook/react';
import { ImageItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/ImageItem',
  component: ImageItem,
  tags: ['autodocs'],
  args: { label: 'ImageItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof ImageItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
