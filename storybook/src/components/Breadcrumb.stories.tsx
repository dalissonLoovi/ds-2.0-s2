import type { Meta, StoryObj } from '@storybook/react';
import { Breadcrumb } from '@ds/react/draft';

const meta = {
  title: 'Draft/Breadcrumb',
  component: Breadcrumb,
  tags: ['autodocs'],
  args: { label: 'Breadcrumb' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Breadcrumb>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
