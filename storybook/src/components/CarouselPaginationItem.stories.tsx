import type { Meta, StoryObj } from '@storybook/react';
import { CarouselPaginationItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/CarouselPaginationItem',
  component: CarouselPaginationItem,
  tags: ['autodocs'],
  args: { label: 'CarouselPaginationItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof CarouselPaginationItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
