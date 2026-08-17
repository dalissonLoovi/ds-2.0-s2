import type { Meta, StoryObj } from '@storybook/react';
import { UploadPhotos } from '@ds/react/draft';

const meta = {
  title: 'Draft/UploadPhotos',
  component: UploadPhotos,
  tags: ['autodocs'],
  args: { label: 'UploadPhotos' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof UploadPhotos>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
