import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Badge.module.css';

export type BadgeProps = HTMLAttributes<HTMLDivElement> & {
  size?: 'sm' | 'lg';
  content?: 'dot' | 'count' | 'overflow';
  label?: string;
  children?: ReactNode;
};

export function Badge({
  size = 'sm',
  content = 'dot',
  label = 'Badge',
  children,
  className,
  ...rest
}: BadgeProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-size={size}
      data-content={content}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Badge · DS React</p>
    </div>
  );
}
