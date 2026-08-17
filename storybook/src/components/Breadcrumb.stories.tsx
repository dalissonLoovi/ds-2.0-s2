import type { Meta, StoryObj } from '@storybook/react';
import { Breadcrumb } from '@ds/react';

const meta = {
  title: 'Components/Breadcrumb',
  component: Breadcrumb,
  tags: ['autodocs'],
  args: { label: 'Breadcrumb' },
} satisfies Meta<typeof Breadcrumb>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
