import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './DashboardCardSecondary.module.css';

export type DashboardCardSecondaryProps = HTMLAttributes<HTMLDivElement> & {
  type?: 'web' | 'mobile';
  growth?: 'up' | 'down';
  label?: string;
  children?: ReactNode;
};

export function DashboardCardSecondary({
  type = 'web',
  growth = 'up',
  label = 'DashboardCardSecondary',
  children,
  className,
  ...rest
}: DashboardCardSecondaryProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-type={type}
      data-growth={growth}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>DashboardCardSecondary · DS React</p>
    </div>
  );
}
