import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './FileUploaderItem.module.css';

export type FileUploaderItemProps = HTMLAttributes<HTMLDivElement> & {
  size?: 'sm' | 'md' | 'lg';
  state?: 'uploaded' | 'loading' | 'success' | 'focus' | 'danger-short' | 'danger-long';
  label?: string;
  children?: ReactNode;
};

export function FileUploaderItem({
  size = 'sm',
  state = 'uploaded',
  label = 'FileUploaderItem',
  children,
  className,
  ...rest
}: FileUploaderItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-size={size}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>FileUploaderItem · DS React</p>
    </div>
  );
}
