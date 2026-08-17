import type { Meta, StoryObj } from '@storybook/react';
import { TextHeader } from '@ds/react/draft';

const meta = {
  title: 'Draft/TextHeader',
  component: TextHeader,
  tags: ['autodocs'],
  args: { label: 'TextHeader' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof TextHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
