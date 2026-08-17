import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Breadcrumb.module.css';

export type BreadcrumbProps = HTMLAttributes<HTMLDivElement> & {
  size?: 'md' | 'sm';
  label?: string;
  children?: ReactNode;
};

export function Breadcrumb({
  size = 'md',
  label = 'Breadcrumb',
  children,
  className,
  ...rest
}: BreadcrumbProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-size={size}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Breadcrumb · DS React</p>
    </div>
  );
}
