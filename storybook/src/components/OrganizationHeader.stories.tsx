import type { Meta, StoryObj } from '@storybook/react';
import { OrganizationHeader } from '@ds/react';

const meta = {
  title: 'Components/OrganizationHeader',
  component: OrganizationHeader,
  tags: ['autodocs'],
  args: { title: 'Artifact', project: 'DS 2.0', type: 'Page' },
} satisfies Meta<typeof OrganizationHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
