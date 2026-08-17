import type { Meta, StoryObj } from '@storybook/react';
import { PaginationSelectMenu } from '@ds/react';

const meta = {
  title: 'Components/PaginationSelectMenu',
  component: PaginationSelectMenu,
  tags: ['autodocs'],
  args: { label: 'PaginationSelectMenu' },
} satisfies Meta<typeof PaginationSelectMenu>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
