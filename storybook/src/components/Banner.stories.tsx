import type { Meta, StoryObj } from '@storybook/react';
import { Banner } from '@ds/react/draft';

const meta = {
  title: 'Draft/Banner',
  component: Banner,
  tags: ['autodocs'],
  args: { label: 'Banner' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Banner>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
