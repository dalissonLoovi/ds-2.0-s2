import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListItemImageThumbnail.module.css';

export type ListItemImageThumbnailProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function ListItemImageThumbnail({

  label = 'ListItemImageThumbnail',
  children,
  className,
  ...rest
}: ListItemImageThumbnailProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ListItemImageThumbnail · DS React</p>
    </div>
  );
}
