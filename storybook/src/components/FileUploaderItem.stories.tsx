import type { Meta, StoryObj } from '@storybook/react';
import { FileUploaderItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/FileUploaderItem',
  component: FileUploaderItem,
  tags: ['autodocs'],
  args: { label: 'FileUploaderItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof FileUploaderItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
