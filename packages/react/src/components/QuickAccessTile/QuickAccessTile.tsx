import type { ButtonHTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './QuickAccessTile.module.css';

export type QuickAccessTileState = 'default' | 'pressed' | 'disabled';

export type QuickAccessTileProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'type'> & {
  state?: QuickAccessTileState;
  label?: string;
  icon?: DsIconName | IconComponent | ReactNode;
};

export function QuickAccessTile({
  state = 'default',
  label = 'Label',
  icon = 'apps-outline',
  disabled = false,
  className,
  ...rest
}: QuickAccessTileProps) {
  const isDisabled = disabled || state === 'disabled';
  const Icon =
    typeof icon === 'string' || typeof icon === 'function'
      ? resolveIcon(icon as DsIconName | IconComponent)
      : null;

  return (
    <button
      type="button"
      className={cx(styles.root, styles[`state-${state}`], isDisabled && styles.disabled, className)}
      disabled={isDisabled}
      data-state={isDisabled ? 'disabled' : state}
      {...rest}
    >
      {state === 'pressed' && !isDisabled ? <span className={styles.stateLayer} aria-hidden /> : null}
      <span className={styles.icon} aria-hidden>
        {Icon ? <Icon size={24} /> : (icon as ReactNode)}
      </span>
      <span className={styles.label}>{label}</span>
    </button>
  );
}
