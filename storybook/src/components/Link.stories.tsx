import type { Meta, StoryObj } from '@storybook/react';
import { Link } from '@ds/react';

const meta = {
  title: 'Components/Link',
  component: Link,
  tags: ['autodocs'],
  args: { label: 'Link', size: 'md', href: '#' },
} satisfies Meta<typeof Link>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
