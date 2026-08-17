import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './AvatarGroup.module.css';

export type AvatarGroupProps = HTMLAttributes<HTMLDivElement> & {
  size?: 'micro' | 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  label?: string;
  children?: ReactNode;
};

export function AvatarGroup({
  size = 'micro',
  label = 'AvatarGroup',
  children,
  className,
  ...rest
}: AvatarGroupProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-size={size}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>AvatarGroup · DS React</p>
    </div>
  );
}
