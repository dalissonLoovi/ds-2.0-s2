import type { Meta, StoryObj } from '@storybook/react';
import { SectionHeader } from '@ds/react/draft';

const meta = {
  title: 'Draft/SectionHeader',
  component: SectionHeader,
  tags: ['autodocs'],
  args: { label: 'SectionHeader' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof SectionHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
