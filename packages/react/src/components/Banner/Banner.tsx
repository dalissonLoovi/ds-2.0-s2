import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Banner.module.css';

export type BannerProps = HTMLAttributes<HTMLDivElement> & {
  status?: 'success' | 'warning' | 'info' | 'danger';
  label?: string;
  children?: ReactNode;
};

export function Banner({
  status = 'success',
  label = 'Banner',
  children,
  className,
  ...rest
}: BannerProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-status={status}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Banner · DS React</p>
    </div>
  );
}
