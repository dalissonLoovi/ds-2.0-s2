import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './DatePickerSelect.module.css';

export type DatePickerSelectProps = HTMLAttributes<HTMLDivElement> & {
  format?: 'day-month-year' | 'day-month' | 'month-year' | 'year';
  state?: 'default' | 'hover' | 'focus' | 'disabled';
  label?: string;
  children?: ReactNode;
};

export function DatePickerSelect({
  format = 'day-month-year',
  state = 'default',
  label = 'DatePickerSelect',
  children,
  className,
  ...rest
}: DatePickerSelectProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-format={format}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>DatePickerSelect · DS React</p>
    </div>
  );
}
