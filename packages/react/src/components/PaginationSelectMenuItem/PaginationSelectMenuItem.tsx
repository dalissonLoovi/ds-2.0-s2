import type { ButtonHTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './PaginationSelectMenuItem.module.css';

export type PaginationSelectMenuItemState =
  | 'default'
  | 'hover'
  | 'pressed'
  | 'selected'
  | 'disabled'
  | 'focus';

export type PaginationSelectMenuItemProps = Omit<
  ButtonHTMLAttributes<HTMLButtonElement>,
  'type'
> & {
  state?: PaginationSelectMenuItemState;
  label?: string;
};

export function PaginationSelectMenuItem({
  state = 'default',
  label = '1',
  disabled = false,
  className,
  ...rest
}: PaginationSelectMenuItemProps) {
  const isDisabled = disabled || state === 'disabled';
  const selected = state === 'selected';

  return (
    <button
      type="button"
      role="option"
      className={cx(styles.root, styles[`state-${state}`], isDisabled && styles.disabled, className)}
      disabled={isDisabled}
      aria-selected={selected || undefined}
      aria-disabled={isDisabled || undefined}
      data-state={isDisabled ? 'disabled' : state}
      {...rest}
    >
      {label}
    </button>
  );
}
