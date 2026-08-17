import type { Meta, StoryObj } from '@storybook/react';
import { Overlay } from '@ds/react/draft';

const meta = {
  title: 'Draft/Overlay',
  component: Overlay,
  tags: ['autodocs'],
  args: { label: 'Overlay' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Overlay>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
