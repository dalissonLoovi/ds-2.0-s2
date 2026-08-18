import type { Meta, StoryObj } from '@storybook/react';
import { BreadcrumbItem } from '@ds/react';

const meta = {
  title: 'Components/BreadcrumbItem',
  component: BreadcrumbItem,
  tags: ['autodocs'],
  args: { label: 'Section', type: 'link' },
} satisfies Meta<typeof BreadcrumbItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
