import type { ButtonHTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './TabItem.module.css';

export type TabItemVariant = 'primary' | 'secondary' | 'segmented';
export type TabItemState = 'default' | 'hover' | 'selected' | 'disabled';
export type TabItemPlatform = 'web' | 'mobile';
export type TabItemAppearance = 'default' | 'inverse';

export type TabItemProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'type'> & {
  variant?: TabItemVariant;
  state?: TabItemState;
  platform?: TabItemPlatform;
  appearance?: TabItemAppearance;
  label?: string;
  showIcon?: boolean;
  leadingIcon?: DsIconName | IconComponent | ReactNode;
  showAttention?: boolean;
  attentionIcon?: DsIconName | IconComponent | ReactNode;
};

export function TabItem({
  variant = 'primary',
  state = 'default',
  platform = 'web',
  appearance = 'default',
  label = 'Tab',
  showIcon = false,
  leadingIcon = 'search-outline',
  showAttention = false,
  attentionIcon = 'alert-circle-filled',
  disabled = false,
  className,
  ...rest
}: TabItemProps) {
  const isDisabled = disabled || state === 'disabled';
  const selected = state === 'selected';
  const inverse = appearance === 'inverse' && variant === 'primary' && platform === 'mobile';
  const Leading =
    typeof leadingIcon === 'string' || typeof leadingIcon === 'function'
      ? resolveIcon(leadingIcon as DsIconName | IconComponent)
      : null;
  const Attention =
    typeof attentionIcon === 'string' || typeof attentionIcon === 'function'
      ? resolveIcon(attentionIcon as DsIconName | IconComponent)
      : null;

  return (
    <button
      type="button"
      role="tab"
      className={cx(
        styles.root,
        styles[`variant-${variant}`],
        styles[`platform-${platform}`],
        inverse && styles.inverse,
        selected && styles.selected,
        isDisabled && styles.disabled,
        className,
      )}
      aria-selected={selected}
      aria-disabled={isDisabled || undefined}
      disabled={isDisabled}
      data-variant={variant}
      data-state={isDisabled ? 'disabled' : state}
      data-platform={platform}
      data-appearance={inverse ? 'inverse' : 'default'}
      {...rest}
    >
      {showIcon && (
        <span className={styles.icon} aria-hidden>
          {Leading ? <Leading size={16} /> : (leadingIcon as ReactNode)}
        </span>
      )}
      <span className={styles.label}>{label}</span>
      {showAttention && (
        <span className={styles.attention} aria-hidden>
          {Attention ? <Attention size={12} /> : (attentionIcon as ReactNode)}
        </span>
      )}
    </button>
  );
}
