import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './List.module.css';

export type ListProps = HTMLAttributes<HTMLDivElement> & {
  type?: 'plain' | 'dropdown';
  label?: string;
  children?: ReactNode;
};

export function List({
  type = 'plain',
  label = 'List',
  children,
  className,
  ...rest
}: ListProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-type={type}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>List · DS React</p>
    </div>
  );
}
