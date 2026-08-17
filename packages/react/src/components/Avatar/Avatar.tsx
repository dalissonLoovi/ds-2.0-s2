import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { LoadingSpinner } from '../LoadingSpinner/LoadingSpinner';
import styles from './Avatar.module.css';

export type AvatarContent = 'image' | 'initials' | 'placeholder';
export type AvatarSize = 'micro' | 'xs' | 'sm' | 'md' | 'lg' | 'xl';
export type AvatarState = 'default' | 'hover' | 'focus' | 'disabled' | 'loading';

export type AvatarProps = HTMLAttributes<HTMLSpanElement> & {
  content?: AvatarContent;
  size?: AvatarSize;
  state?: AvatarState;
  src?: string;
  alt?: string;
  initials?: string;
};

const SIZE_PX = { micro: 16, xs: 20, sm: 24, md: 32, lg: 40, xl: 56 } as const;

export function Avatar({
  content = 'placeholder',
  size = 'md',
  state = 'default',
  src,
  alt = '',
  initials = 'AB',
  className,
  ...rest
}: AvatarProps) {
  const loading = state === 'loading';
  const disabled = state === 'disabled';
  const resolved = src ? 'image' : content;

  return (
    <span
      className={cx(
        styles.root,
        styles[`size-${size}`],
        styles[`state-${state}`],
        disabled && styles.disabled,
        className,
      )}
      data-content={resolved}
      data-size={size}
      data-state={state}
      aria-hidden={!alt || undefined}
      aria-label={alt || undefined}
      {...rest}
    >
      {loading ? (
        <LoadingSpinner size="sm" decorative />
      ) : resolved === 'image' && src ? (
        <img className={styles.image} src={src} alt={alt} />
      ) : resolved === 'initials' ? (
        <span className={styles.initials}>{initials.slice(0, 2)}</span>
      ) : (
        <span className={styles.placeholder} aria-hidden />
      )}
    </span>
  );
}

export { SIZE_PX as avatarSizePx };
