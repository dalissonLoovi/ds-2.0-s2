import type { Meta, StoryObj } from '@storybook/react';
import { Link } from '@ds/react';

const meta = {
  title: 'Components/Link',
  component: Link,
  tags: ['autodocs'],
  args: {
    label: 'Link',
    size: 'lg',
    href: '#',
    showIcon: true,
    inline: false,
    appearance: 'default',
    state: 'default',
  },
  argTypes: {
    size: { control: 'select', options: ['lg', 'md', 'sm'] },
    state: {
      control: 'select',
      options: ['default', 'hover', 'focus', 'active', 'visited', 'disabled'],
    },
    appearance: { control: 'select', options: ['default', 'inverse'] },
    inline: { control: 'boolean' },
    showIcon: { control: 'boolean' },
  },
} satisfies Meta<typeof Link>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};

export const Sizes: Story = {
  render: (args) => (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
      <Link {...args} size="lg" label="Large link" />
      <Link {...args} size="md" label="Medium link" />
      <Link {...args} size="sm" label="Small link" />
    </div>
  ),
};

export const Inline: Story = {
  args: {
    inline: true,
    showIcon: false,
    label: 'Inline link',
  },
};

export const Inverse: Story = {
  args: {
    appearance: 'inverse',
    label: 'Inverse link',
  },
  parameters: {
    backgrounds: { default: 'dark' },
  },
};

export const States: Story = {
  render: (args) => (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
      {(['default', 'hover', 'focus', 'active', 'visited', 'disabled'] as const).map((state) => (
        <Link {...args} key={state} state={state} label={`${state} link`} />
      ))}
    </div>
  ),
};

export const WithoutIcon: Story = {
  args: {
    showIcon: false,
    label: 'Link without icon',
  },
};
