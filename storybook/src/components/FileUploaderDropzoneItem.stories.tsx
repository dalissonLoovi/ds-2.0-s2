import type { Meta, StoryObj } from '@storybook/react';
import { FileUploaderDropzoneItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/FileUploaderDropzoneItem',
  component: FileUploaderDropzoneItem,
  tags: ['autodocs'],
  args: { label: 'FileUploaderDropzoneItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof FileUploaderDropzoneItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
