import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './CalendarDay.module.css';

export type CalendarDayProps = HTMLAttributes<HTMLDivElement> & {
  kind?: 'default' | 'today' | 'range-start' | 'range-middle' | 'range-end' | 'outside';
  state?: 'default' | 'hover' | 'focus' | 'selected' | 'disabled';
  label?: string;
  children?: ReactNode;
};

export function CalendarDay({
  kind = 'default',
  state = 'default',
  label = 'CalendarDay',
  children,
  className,
  ...rest
}: CalendarDayProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-kind={kind}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>CalendarDay · DS React</p>
    </div>
  );
}
