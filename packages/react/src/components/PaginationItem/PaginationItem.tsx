import type { ButtonHTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import styles from './PaginationItem.module.css';

export type PaginationItemContent = 'number' | 'overflow';
export type PaginationItemState = 'default' | 'hover' | 'focus' | 'disabled';

export type PaginationItemProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'type'> & {
  content?: PaginationItemContent;
  state?: PaginationItemState;
  selected?: boolean;
  label?: string;
};

export function PaginationItem({
  content = 'number',
  state = 'default',
  selected = false,
  label = '1',
  disabled = false,
  className,
  'aria-label': ariaLabel,
  ...rest
}: PaginationItemProps) {
  const isDisabled = disabled || state === 'disabled';
  const Dots = resolveIcon('dots-outline');

  if (content === 'overflow') {
    return (
      <span
        className={cx(styles.root, styles.overflow, className)}
        data-content="overflow"
        aria-hidden
      >
        {Dots ? <Dots size={16} /> : '…'}
      </span>
    );
  }

  return (
    <button
      type="button"
      className={cx(
        styles.root,
        styles.number,
        styles[`state-${state}`],
        selected && styles.selected,
        isDisabled && styles.disabled,
        className,
      )}
      disabled={isDisabled}
      aria-current={selected ? 'page' : undefined}
      aria-label={ariaLabel ?? `Page ${label}`}
      data-content="number"
      data-state={isDisabled ? 'disabled' : state}
      data-selected={selected}
      {...rest}
    >
      {label}
    </button>
  );
}
