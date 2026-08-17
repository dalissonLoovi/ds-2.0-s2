import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './FileUploaderDropzoneItem.module.css';

export type FileUploaderDropzoneItemProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'drag-hover' | 'focus' | 'disabled';
  label?: string;
  children?: ReactNode;
};

export function FileUploaderDropzoneItem({
  state = 'default',
  label = 'FileUploaderDropzoneItem',
  children,
  className,
  ...rest
}: FileUploaderDropzoneItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>FileUploaderDropzoneItem · DS React</p>
    </div>
  );
}
