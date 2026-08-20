import type { ButtonHTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './ListActionDropdownItem.module.css';

export type ListActionDropdownItemState =
  | 'default'
  | 'hover'
  | 'pressed'
  | 'selected'
  | 'focus'
  | 'disabled';

export type ListActionDropdownItemProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'type'> & {
  state?: ListActionDropdownItemState;
  label?: string;
  showIcon?: boolean;
  icon?: DsIconName | IconComponent | ReactNode;
};

export function ListActionDropdownItem({
  state = 'default',
  label = 'Action',
  showIcon = true,
  icon = 'edit-outline',
  disabled = false,
  className,
  ...rest
}: ListActionDropdownItemProps) {
  const isDisabled = disabled || state === 'disabled';
  const Icon =
    typeof icon === 'string' || typeof icon === 'function'
      ? resolveIcon(icon as DsIconName | IconComponent)
      : null;

  return (
    <button
      type="button"
      role="menuitem"
      className={cx(
        styles.root,
        styles[`state-${state}`],
        isDisabled && styles.disabled,
        className,
      )}
      disabled={isDisabled}
      aria-disabled={isDisabled || undefined}
      data-state={isDisabled ? 'disabled' : state}
      {...rest}
    >
      {showIcon && (
        <span className={styles.icon} aria-hidden>
          {Icon ? <Icon size={20} /> : (icon as ReactNode)}
        </span>
      )}
      <span className={styles.label}>{label}</span>
    </button>
  );
}
