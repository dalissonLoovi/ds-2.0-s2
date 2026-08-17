import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TableRow.module.css';

export type TableRowProps = HTMLAttributes<HTMLDivElement> & {
  type?: 'header' | 'body';
  cellCount?: '3' | '4' | '5' | '6' | '7' | '8' | '9';
  state?: 'default' | 'hover' | 'pressed' | 'selected' | 'focus';
  label?: string;
  children?: ReactNode;
};

export function TableRow({
  type = 'header',
  cellCount = '3',
  state = 'default',
  label = 'TableRow',
  children,
  className,
  ...rest
}: TableRowProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-type={type}
      data-cellCount={cellCount}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TableRow · DS React</p>
    </div>
  );
}
