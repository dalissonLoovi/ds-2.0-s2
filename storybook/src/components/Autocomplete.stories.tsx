import type { Meta, StoryObj } from '@storybook/react';
import { Autocomplete } from '@ds/react/draft';

const meta = {
  title: 'Draft/Autocomplete',
  component: Autocomplete,
  tags: ['autodocs'],
  args: { label: 'Autocomplete' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof Autocomplete>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
