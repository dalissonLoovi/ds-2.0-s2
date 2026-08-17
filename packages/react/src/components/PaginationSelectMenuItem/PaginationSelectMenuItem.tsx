import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './PaginationSelectMenuItem.module.css';

export type PaginationSelectMenuItemProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'pressed' | 'selected' | 'disabled' | 'focus';
  label?: string;
  children?: ReactNode;
};

export function PaginationSelectMenuItem({
  state = 'default',
  label = 'PaginationSelectMenuItem',
  children,
  className,
  ...rest
}: PaginationSelectMenuItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>PaginationSelectMenuItem · DS React</p>
    </div>
  );
}
