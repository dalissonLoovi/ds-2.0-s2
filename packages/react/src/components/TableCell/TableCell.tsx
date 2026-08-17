import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TableCell.module.css';

export type TableCellProps = HTMLAttributes<HTMLDivElement> & {
  type?: 'header' | 'primary' | 'secondary' | 'tertiary' | 'slot';
  state?: 'default' | 'hover' | 'pressed' | 'selected';
  label?: string;
  children?: ReactNode;
};

export function TableCell({
  type = 'header',
  state = 'default',
  label = 'TableCell',
  children,
  className,
  ...rest
}: TableCellProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-type={type}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TableCell · DS React</p>
    </div>
  );
}
