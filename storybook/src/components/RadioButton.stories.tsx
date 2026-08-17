import type { Meta, StoryObj } from '@storybook/react';
import { RadioButton } from '@ds/react/draft';

const meta = {
  title: 'Draft/RadioButton',
  component: RadioButton,
  tags: ['autodocs'],
  args: { label: 'RadioButton' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof RadioButton>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
