import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './PaginationSelectInput.module.css';

export type PaginationSelectInputProps = HTMLAttributes<HTMLDivElement> & {
  size?: 'sm' | 'md' | 'lg';
  state?: 'default' | 'hover';
  expanded?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function PaginationSelectInput({
  size = 'sm',
  state = 'default',
  expanded = 'false',
  label = 'PaginationSelectInput',
  children,
  className,
  ...rest
}: PaginationSelectInputProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-size={size}
      data-state={state}
      data-expanded={expanded}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>PaginationSelectInput · DS React</p>
    </div>
  );
}
