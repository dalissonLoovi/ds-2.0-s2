import type { Meta, StoryObj } from '@storybook/react';
import { PhotoTextItem } from '@ds/react';

const meta = {
  title: 'Components/PhotoTextItem',
  component: PhotoTextItem,
  tags: ['autodocs'],
  args: { label: 'Label', showSupportingText: true },
} satisfies Meta<typeof PhotoTextItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
