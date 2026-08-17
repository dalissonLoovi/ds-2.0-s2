import type { Meta, StoryObj } from '@storybook/react';
import { Link } from '@ds/react/draft';

const meta = {
  title: 'Draft/Link',
  component: Link,
  tags: ['autodocs'],
  args: { label: 'Link' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Link>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
