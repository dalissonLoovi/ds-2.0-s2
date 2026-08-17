import type { Meta, StoryObj } from '@storybook/react';
import { InputTextArea } from '@ds/react/draft';

const meta = {
  title: 'Draft/InputTextArea',
  component: InputTextArea,
  tags: ['autodocs'],
  args: { label: 'InputTextArea' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof InputTextArea>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
