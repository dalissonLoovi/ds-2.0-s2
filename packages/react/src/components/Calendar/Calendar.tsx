import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Calendar.module.css';

export type CalendarProps = HTMLAttributes<HTMLDivElement> & {
  mode?: 'simple' | 'month' | 'month-year' | 'complete' | 'time';
  picker?: 'default' | 'month' | 'year';
  platform?: 'mobile' | 'web';
  label?: string;
  children?: ReactNode;
};

export function Calendar({
  mode = 'simple',
  picker = 'default',
  platform = 'mobile',
  label = 'Calendar',
  children,
  className,
  ...rest
}: CalendarProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-mode={mode}
      data-picker={picker}
      data-platform={platform}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Calendar · DS React</p>
    </div>
  );
}
