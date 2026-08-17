import type { Meta, StoryObj } from '@storybook/react';
import { FileUploader } from '@ds/react/draft';

const meta = {
  title: 'Draft/FileUploader',
  component: FileUploader,
  tags: ['autodocs'],
  args: { label: 'FileUploader' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof FileUploader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
