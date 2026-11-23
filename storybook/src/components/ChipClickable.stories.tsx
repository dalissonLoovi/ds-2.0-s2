import type { Meta, StoryObj } from '@storybook/react';
import { ChipClickable } from '@ds/react';

const meta = {
  title: 'Components/ChipClickable',
  component: ChipClickable,
  tags: ['autodocs'],
  args: {
    label: 'Adicionar veículo',
    intent: 'soft',
    size: 'md',
    showLeadingIcon: true,
    leadingIcon: 'plus-outline',
  },
} satisfies Meta<typeof ChipClickable>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Soft: Story = {};
export const Selected: Story = { args: { selected: true, intent: 'outline', label: 'Filter' } };
/** intent=brand → color/background-surface/brand-strong + text/on-color (AA). */
export const Brand: Story = {
  args: { intent: 'brand', label: 'Loovi', showLeadingIcon: false },
};

/** Default since 2026-11-23: status intents render emphasis=secondary (soft fill). */
export const SecondaryInfo: Story = {
  args: { intent: 'info', label: 'Info', showLeadingIcon: false },
};

/** emphasis=primary (strong fill) is opt-in. */
export const PrimaryInfo: Story = {
  args: { intent: 'info', emphasis: 'primary', label: 'Info', showLeadingIcon: false },
};

/** Avatar sm 20 / md 32; deleteAction 16×16 with a 24×24 invisible hit area ("Remover {label}"). */
export const AvatarAndDelete: Story = {
  render: () => (
    <div style={{ display: 'flex', gap: 'var(--spacing-100)', alignItems: 'center' }}>
      {(['sm', 'md'] as const).map((size) => (
        <ChipClickable
          key={size}
          size={size}
          intent="outline"
          label={`Maria (${size})`}
          showAvatar
          showDeleteAction
          onDelete={() => undefined}
        />
      ))}
    </div>
  ),
};

export const EmphasisMatrix: Story = {
  render: () => (
    <div style={{ display: 'flex', flexWrap: 'wrap', gap: 'var(--spacing-100)' }}>
      {(['info', 'system', 'success', 'warning', 'danger'] as const).flatMap((intent) =>
        (['primary', 'secondary'] as const).map((emphasis) => (
          <ChipClickable key={`${intent}-${emphasis}`} intent={intent} emphasis={emphasis} label={`${intent} · ${emphasis}`} />
        )),
      )}
    </div>
  ),
};
