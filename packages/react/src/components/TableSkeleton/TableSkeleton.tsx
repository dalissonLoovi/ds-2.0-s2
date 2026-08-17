import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TableSkeleton.module.css';

export type TableSkeletonProps = HTMLAttributes<HTMLDivElement> & {
  empty?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function TableSkeleton({
  empty = 'false',
  label = 'TableSkeleton',
  children,
  className,
  ...rest
}: TableSkeletonProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-empty={empty}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TableSkeleton · DS React</p>
    </div>
  );
}
