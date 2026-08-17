import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListItemVideoThumbnail.module.css';

export type ListItemVideoThumbnailProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function ListItemVideoThumbnail({

  label = 'ListItemVideoThumbnail',
  children,
  className,
  ...rest
}: ListItemVideoThumbnailProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ListItemVideoThumbnail · DS React</p>
    </div>
  );
}
