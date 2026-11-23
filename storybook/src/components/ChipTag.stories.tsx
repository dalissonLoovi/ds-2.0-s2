import type { Meta, StoryObj } from '@storybook/react';
import { ChipTag } from '@ds/react';

const meta = {
  title: 'Components/ChipTag',
  component: ChipTag,
  tags: ['autodocs'],
  args: {
    label: 'Ativo',
    intent: 'success',
    emphasis: 'secondary',
    size: 'md',
    width: 'hug',
    showLeadingIcon: true,
  },
} satisfies Meta<typeof ChipTag>;

export default meta;
type Story = StoryObj<typeof meta>;

/** Default since 2026-11-23: emphasis=secondary (soft fill). */
export const SecondarySuccess: Story = {};

/** emphasis=primary (strong fill) is opt-in. */
export const PrimarySuccess: Story = {
  args: { emphasis: 'primary' },
};

export const Outline: Story = {
  args: { intent: 'outline', label: 'Tag', showLeadingIcon: false },
};

/** intent=brand → color/background-surface/brand-strong + text/on-color (AA); ignores emphasis. */
export const Brand: Story = {
  args: { intent: 'brand', label: 'Loovi', showLeadingIcon: false },
};

export const EmphasisMatrix: Story = {
  render: () => (
    <div style={{ display: 'flex', flexWrap: 'wrap', gap: 'var(--spacing-100)' }}>
      {(['info', 'system', 'success', 'warning', 'danger'] as const).flatMap((intent) =>
        (['primary', 'secondary'] as const).map((emphasis) => (
          <ChipTag key={`${intent}-${emphasis}`} intent={intent} emphasis={emphasis} label={`${intent} · ${emphasis}`} showLeadingIcon={false} />
        )),
      )}
    </div>
  ),
};
