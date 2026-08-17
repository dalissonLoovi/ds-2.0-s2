import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Pagination.module.css';

export type PaginationProps = HTMLAttributes<HTMLDivElement> & {
  position?: 'start' | 'middle' | 'end';
  size?: 'lg' | 'sm';
  label?: string;
  children?: ReactNode;
};

export function Pagination({
  position = 'start',
  size = 'lg',
  label = 'Pagination',
  children,
  className,
  ...rest
}: PaginationProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-position={position}
      data-size={size}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Pagination · DS React</p>
    </div>
  );
}
