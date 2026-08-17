import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './FileUploader.module.css';

export type FileUploaderProps = HTMLAttributes<HTMLDivElement> & {
  variant?: 'default' | 'drag-and-drop';
  size?: 'lg' | 'md' | 'sm';
  state?: 'default' | 'disabled' | 'skeleton';
  label?: string;
  children?: ReactNode;
};

export function FileUploader({
  variant = 'default',
  size = 'lg',
  state = 'default',
  label = 'FileUploader',
  children,
  className,
  ...rest
}: FileUploaderProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-variant={variant}
      data-size={size}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>FileUploader · DS React</p>
    </div>
  );
}
