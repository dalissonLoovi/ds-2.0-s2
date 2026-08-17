import type { Meta, StoryObj } from '@storybook/react';
import { BreadcrumbItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/BreadcrumbItem',
  component: BreadcrumbItem,
  tags: ['autodocs'],
  args: { label: 'BreadcrumbItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof BreadcrumbItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
