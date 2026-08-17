import type { Meta, StoryObj } from '@storybook/react';
import { Carousel } from '@ds/react/draft';

const meta = {
  title: 'Draft/Carousel',
  component: Carousel,
  tags: ['autodocs'],
  args: { label: 'Carousel' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Carousel>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
