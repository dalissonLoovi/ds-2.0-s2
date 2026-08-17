import type { ButtonHTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './CalendarDay.module.css';

export type CalendarDayKind =
  | 'default'
  | 'today'
  | 'range-start'
  | 'range-middle'
  | 'range-end'
  | 'outside';
export type CalendarDayState = 'default' | 'hover' | 'focus' | 'selected' | 'disabled';

export type CalendarDayProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'type'> & {
  kind?: CalendarDayKind;
  state?: CalendarDayState;
  day?: string;
};

export function CalendarDay({
  kind = 'default',
  state = 'default',
  day = '1',
  disabled = false,
  className,
  ...rest
}: CalendarDayProps) {
  const isDisabled = disabled || state === 'disabled';
  const isSelected = state === 'selected' || kind === 'range-start' || kind === 'range-end';

  return (
    <button
      type="button"
      className={cx(
        styles.root,
        styles[`kind-${kind}`],
        styles[`state-${state}`],
        isSelected && styles.selected,
        isDisabled && styles.disabled,
        className,
      )}
      disabled={isDisabled}
      aria-disabled={isDisabled || undefined}
      role="gridcell"
      aria-selected={isSelected || undefined}
      aria-current={kind === 'today' && !isSelected && !isDisabled ? 'date' : undefined}
      data-kind={kind}
      data-state={isDisabled ? 'disabled' : state}
      {...rest}
    >
      <span className={styles.pill}>{day}</span>
    </button>
  );
}
