import type { Meta, StoryObj } from '@storybook/react';
import { SectionHeader } from '@ds/react';

const meta = {
  title: 'Components/SectionHeader',
  component: SectionHeader,
  tags: ['autodocs'],
  args: { title: 'Section', emphasis: 'primary', showAction: true },
} satisfies Meta<typeof SectionHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
