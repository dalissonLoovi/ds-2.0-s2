import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Table.module.css';

export type TableProps = HTMLAttributes<HTMLDivElement> & {
  columns?: '3' | '4' | '5' | '6' | '7' | '8' | '9';
  label?: string;
  children?: ReactNode;
};

export function Table({
  columns = '3',
  label = 'Table',
  children,
  className,
  ...rest
}: TableProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-columns={columns}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Table · DS React</p>
    </div>
  );
}
