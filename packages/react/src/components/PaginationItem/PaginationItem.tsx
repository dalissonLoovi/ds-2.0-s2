import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './PaginationItem.module.css';

export type PaginationItemProps = HTMLAttributes<HTMLDivElement> & {
  content?: 'number' | 'overflow';
  state?: 'default' | 'hover' | 'focus' | 'disabled';
  selected?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function PaginationItem({
  content = 'number',
  state = 'default',
  selected = 'false',
  label = 'PaginationItem',
  children,
  className,
  ...rest
}: PaginationItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-content={content}
      data-state={state}
      data-selected={selected}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>PaginationItem · DS React</p>
    </div>
  );
}
