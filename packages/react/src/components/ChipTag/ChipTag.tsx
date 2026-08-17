import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './ChipTag.module.css';

export type ChipTagSize = 'sm' | 'md';
export type ChipTagIntent = 'info' | 'system' | 'success' | 'warning' | 'danger' | 'outline';
export type ChipTagWidth = 'hug' | 'fill';
export type ChipTagState = 'default' | 'disabled';
export type ChipTagEmphasis = 'strong' | 'soft';

export type ChipTagProps = HTMLAttributes<HTMLSpanElement> & {
  size?: ChipTagSize;
  intent?: ChipTagIntent;
  width?: ChipTagWidth;
  state?: ChipTagState;
  emphasis?: ChipTagEmphasis;
  label?: string;
  showLeadingIcon?: boolean;
  leadingIcon?: DsIconName | IconComponent | ReactNode;
  showAvatar?: boolean;
};

export function ChipTag({
  size = 'md',
  intent = 'info',
  width = 'hug',
  state = 'default',
  emphasis = 'strong',
  label = 'Label',
  showLeadingIcon = false,
  leadingIcon = 'circle-check-filled',
  showAvatar = false,
  className,
  ...rest
}: ChipTagProps) {
  const Icon =
    typeof leadingIcon === 'string' || typeof leadingIcon === 'function'
      ? resolveIcon(leadingIcon as DsIconName | IconComponent)
      : null;
  const leadingNode =
    showLeadingIcon &&
    (Icon ? (
      <Icon size={size === 'sm' ? 14 : 16} aria-hidden className={styles.icon} />
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
