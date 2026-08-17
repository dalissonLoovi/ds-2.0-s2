import type { Meta, StoryObj } from '@storybook/react';
import { TabsSegmented } from '@ds/react/draft';

const meta = {
  title: 'Draft/TabsSegmented',
  component: TabsSegmented,
  tags: ['autodocs'],
  args: { label: 'TabsSegmented' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof TabsSegmented>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
