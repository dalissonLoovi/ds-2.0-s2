import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import styles from './ListItemVideoThumbnail.module.css';

export type ListItemVideoThumbnailProps = HTMLAttributes<HTMLSpanElement> & {
  src?: string;
  alt?: string;
};

export function ListItemVideoThumbnail({
  src,
  alt = '',
  className,
  ...rest
}: ListItemVideoThumbnailProps) {
  const Play = resolveIcon('player-play-outline');
  return (
    <span className={cx(styles.root, className)} {...rest}>
      {src ? <img className={styles.image} src={src} alt={alt} /> : <span className={styles.fallback} aria-hidden />}
      {Play && <Play size={16} aria-hidden className={styles.play} />}
    </span>
  );
}
