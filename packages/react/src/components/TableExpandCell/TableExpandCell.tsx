import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TableExpandCell.module.css';

export type TableExpandCellProps = HTMLAttributes<HTMLDivElement> & {
  type?: 'body' | 'header';
  state?: 'default' | 'hover' | 'pressed' | 'selected' | 'focus' | 'disabled';
  showChevron?: 'true' | 'false';
  label?: string;
  children?: ReactNode;
};

export function TableExpandCell({
  type = 'body',
  state = 'default',
  showChevron = 'true',
  label = 'TableExpandCell',
  children,
  className,
  ...rest
}: TableExpandCellProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-type={type}
      data-state={state}
      data-showChevron={showChevron}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TableExpandCell · DS React</p>
    </div>
  );
}
