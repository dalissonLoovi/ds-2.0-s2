import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './DashboardCardPrimary.module.css';

export type DashboardCardPrimaryProps = HTMLAttributes<HTMLDivElement> & {
  type?: 'web' | 'mobile';
  label?: string;
  children?: ReactNode;
};

export function DashboardCardPrimary({
  type = 'web',
  label = 'DashboardCardPrimary',
  children,
  className,
  ...rest
}: DashboardCardPrimaryProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-type={type}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>DashboardCardPrimary · DS React</p>
    </div>
  );
}
