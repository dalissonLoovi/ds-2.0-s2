import type { Meta, StoryObj } from '@storybook/react';
import { Accordion } from '@ds/react/draft';

const meta = {
  title: 'Draft/Accordion',
  component: Accordion,
  tags: ['autodocs'],
  args: { label: 'Accordion' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Accordion>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
