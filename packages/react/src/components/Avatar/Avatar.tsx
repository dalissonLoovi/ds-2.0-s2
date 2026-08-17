import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Avatar.module.css';

export type AvatarProps = HTMLAttributes<HTMLDivElement> & {
  content?: 'image' | 'initials' | 'placeholder';
  size?: 'micro' | 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  state?: 'default' | 'hover' | 'focus' | 'disabled' | 'loading';
  label?: string;
  children?: ReactNode;
};

export function Avatar({
  content = 'image',
  size = 'micro',
  state = 'default',
  label = 'Avatar',
  children,
  className,
  ...rest
}: AvatarProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-content={content}
      data-size={size}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Avatar · DS React</p>
    </div>
  );
}
