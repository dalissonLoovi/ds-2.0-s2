import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './UploadPhotos.module.css';

export type UploadPhotosProps = HTMLAttributes<HTMLDivElement> & {
  status?: 'pending' | 'in-review' | 'approved' | 'rejected';
  label?: string;
  children?: ReactNode;
};

export function UploadPhotos({
  status = 'pending',
  label = 'UploadPhotos',
  children,
  className,
  ...rest
}: UploadPhotosProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-status={status}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>UploadPhotos · DS React</p>
    </div>
  );
}
