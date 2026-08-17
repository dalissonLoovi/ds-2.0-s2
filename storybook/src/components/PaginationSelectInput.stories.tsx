import type { Meta, StoryObj } from '@storybook/react';
import { PaginationSelectInput } from '@ds/react';

const meta = {
  title: 'Components/PaginationSelectInput',
  component: PaginationSelectInput,
  tags: ['autodocs'],
  args: { label: 'PaginationSelectInput' },
} satisfies Meta<typeof PaginationSelectInput>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
