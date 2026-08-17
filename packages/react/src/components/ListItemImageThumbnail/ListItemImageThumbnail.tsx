import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListItemImageThumbnail.module.css';

export type ListItemImageThumbnailProps = HTMLAttributes<HTMLSpanElement> & {
  src?: string;
  alt?: string;
};

export function ListItemImageThumbnail({
  src,
  alt = '',
  className,
  ...rest
}: ListItemImageThumbnailProps) {
  return (
    <span className={cx(styles.root, className)} {...rest}>
      {src ? <img className={styles.image} src={src} alt={alt} /> : <span className={styles.fallback} aria-hidden />}
    </span>
  );
}
