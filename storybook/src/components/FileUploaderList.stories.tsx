import type { Meta, StoryObj } from '@storybook/react';
import { FileUploaderList } from '@ds/react/draft';

const meta = {
  title: 'Draft/FileUploaderList',
  component: FileUploaderList,
  tags: ['autodocs'],
  args: { label: 'FileUploaderList' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof FileUploaderList>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
