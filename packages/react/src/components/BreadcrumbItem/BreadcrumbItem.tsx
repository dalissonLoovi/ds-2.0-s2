import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './BreadcrumbItem.module.css';

export type BreadcrumbItemProps = HTMLAttributes<HTMLDivElement> & {
  size?: 'sm' | 'md';
  type?: 'link' | 'overflow';
  state?: 'default' | 'hover' | 'focus' | 'pressed' | 'current' | 'skeleton' | 'open';
  label?: string;
  children?: ReactNode;
};

export function BreadcrumbItem({
  size = 'sm',
  type = 'link',
  state = 'default',
  label = 'BreadcrumbItem',
  children,
  className,
  ...rest
}: BreadcrumbItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-size={size}
      data-type={type}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>BreadcrumbItem · DS React</p>
    </div>
  );
}
