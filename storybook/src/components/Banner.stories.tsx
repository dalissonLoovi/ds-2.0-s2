import type { Meta, StoryObj } from '@storybook/react';
import { Banner } from '@ds/react';

const meta = {
  title: 'Components/Banner',
  component: Banner,
  tags: ['autodocs'],
  args: { status: 'info', message: 'Saved successfully', showAction: true },
} satisfies Meta<typeof Banner>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};

export const Secondary: Story = {
  args: { status: 'success', emphasis: 'secondary', message: 'Pagamento confirmado' },
};

export const EmphasisMatrix: Story = {
  render: () => (
    <div style={{ display: 'grid', gap: 'var(--spacing-100)' }}>
      {(['success', 'info', 'warning', 'danger'] as const).flatMap((status) =>
        (['primary', 'secondary'] as const).map((emphasis) => (
          <Banner key={`${status}-${emphasis}`} status={status} emphasis={emphasis} message={`${status} · ${emphasis}`} showAction={false} />
        )),
      )}
    </div>
  ),
};
