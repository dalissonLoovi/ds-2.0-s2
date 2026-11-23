import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './ChipTag.module.css';

export type ChipTagSize = 'sm' | 'md';
export type ChipTagIntent =
  | 'info'
  | 'system'
  | 'success'
  | 'warning'
  | 'danger'
  | 'outline'
  | 'brand';
export type ChipTagWidth = 'hug' | 'fill';
export type ChipTagState = 'default' | 'disabled';
/** Seed variant axis: `primary` (strong feedback fill) | `secondary` (soft feedback fill). */
export type ChipTagEmphasis = 'primary' | 'secondary';
/**
 * @deprecated Legacy emphasis values (renamed 2026-11-23): `strong` → `primary`, `soft` → `secondary`.
 * Still accepted for backwards compatibility; will be removed in a future major.
 */
export type ChipTagLegacyEmphasis = 'strong' | 'soft';

export type ChipTagProps = HTMLAttributes<HTMLSpanElement> & {
  size?: ChipTagSize;
  intent?: ChipTagIntent;
  width?: ChipTagWidth;
  state?: ChipTagState;
  /**
   * `secondary` (default since 2026-11-23) = color/background-feedback-secondary/{intent} (soft fill);
   * `primary` (opt-in) = color/background-feedback-primary/{intent} (strong fill).
   * `strong` / `soft` are deprecated aliases of `primary` / `secondary`.
   */
  emphasis?: ChipTagEmphasis | ChipTagLegacyEmphasis;
  label?: string;
  showLeadingIcon?: boolean;
  leadingIcon?: DsIconName | IconComponent | ReactNode;
  showAvatar?: boolean;
};

const LEGACY_EMPHASIS: Record<ChipTagLegacyEmphasis, ChipTagEmphasis> = {
  strong: 'primary',
  soft: 'secondary',
};

/** Normalizes deprecated `strong` / `soft` to `primary` / `secondary`. */
export function normalizeChipTagEmphasis(
  emphasis: ChipTagEmphasis | ChipTagLegacyEmphasis,
): ChipTagEmphasis {
  return (LEGACY_EMPHASIS as Record<string, ChipTagEmphasis>)[emphasis] ?? emphasis;
}

export function ChipTag({
  size = 'md',
  intent = 'info',
  width = 'hug',
  state = 'default',
  emphasis: emphasisProp = 'secondary',
  label = 'Label',
  showLeadingIcon = false,
  leadingIcon = 'circle-check-filled',
  showAvatar = false,
  className,
  ...rest
}: ChipTagProps) {
  const emphasis = normalizeChipTagEmphasis(emphasisProp);
  const Icon =
    typeof leadingIcon === 'string' || typeof leadingIcon === 'function'
      ? resolveIcon(leadingIcon as DsIconName | IconComponent)
      : null;
  const leadingNode =
    showLeadingIcon &&
    (Icon ? (
      // Seed rules.iconSize: sm 20 (spacing/250) · md 32 (spacing/400).
      <Icon size={size === 'sm' ? 20 : 32} aria-hidden className={styles.icon} />
    ) : (
      (leadingIcon as ReactNode)
    ));

  return (
    <span
      className={cx(
        styles.root,
        styles[`size-${size}`],
        styles[`intent-${intent}`],
        styles[`width-${width}`],
        styles[`emphasis-${emphasis}`],
        state === 'disabled' && styles.disabled,
        className,
      )}
      data-intent={intent}
      data-emphasis={emphasis}
      aria-disabled={state === 'disabled' || undefined}
      {...rest}
    >
      {showAvatar && <span className={styles.avatar} aria-hidden />}
      {leadingNode}
      <span className={styles.label}>{label}</span>
    </span>
  );
}
