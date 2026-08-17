import type { Meta, StoryObj } from '@storybook/react';
import { InputPassword } from '@ds/react/draft';

const meta = {
  title: 'Draft/InputPassword',
  component: InputPassword,
  tags: ['autodocs'],
  args: { label: 'InputPassword' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof InputPassword>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
