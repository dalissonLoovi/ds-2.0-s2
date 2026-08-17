import type { Meta, StoryObj } from '@storybook/react';
import { Banner } from '@ds/react';

const meta = {
  title: 'Components/Banner',
  component: Banner,
  tags: ['autodocs'],
  args: { label: 'Banner' },
} satisfies Meta<typeof Banner>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
