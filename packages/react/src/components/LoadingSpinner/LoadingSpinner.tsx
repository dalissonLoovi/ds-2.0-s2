import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './LoadingSpinner.module.css';

export type LoadingSpinnerProps = HTMLAttributes<HTMLDivElement> & {
  size?: 'sm' | 'md' | 'lg';
  label?: string;
  children?: ReactNode;
};

export function LoadingSpinner({
  size = 'sm',
  label = 'LoadingSpinner',
  children,
  className,
  ...rest
}: LoadingSpinnerProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-size={size}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>LoadingSpinner · DS React</p>
    </div>
  );
}
