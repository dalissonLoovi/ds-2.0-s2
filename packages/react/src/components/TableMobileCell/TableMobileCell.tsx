import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TableMobileCell.module.css';

export type TableMobileCellProps = HTMLAttributes<HTMLDivElement> & {
  type?: 'primary' | 'secondary' | 'tag' | 'action' | 'icon';
  state?: 'default' | 'hover' | 'pressed' | 'selected';
  label?: string;
  children?: ReactNode;
};

export function TableMobileCell({
  type = 'primary',
  state = 'default',
  label = 'TableMobileCell',
  children,
  className,
  ...rest
}: TableMobileCellProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-type={type}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TableMobileCell · DS React</p>
    </div>
  );
}
