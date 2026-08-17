import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './CalendarPeriodNav.module.css';

export type CalendarPeriodNavProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: 'default' | 'inverse';
  previousDisabled?: 'false' | 'true';
  nextDisabled?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function CalendarPeriodNav({
  appearance = 'default',
  previousDisabled = 'false',
  nextDisabled = 'false',
  label = 'CalendarPeriodNav',
  children,
  className,
  ...rest
}: CalendarPeriodNavProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-appearance={appearance}
      data-previousDisabled={previousDisabled}
      data-nextDisabled={nextDisabled}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>CalendarPeriodNav · DS React</p>
    </div>
  );
}
