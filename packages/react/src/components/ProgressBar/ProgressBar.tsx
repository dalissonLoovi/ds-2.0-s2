import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ProgressBar.module.css';

export type ProgressBarProps = HTMLAttributes<HTMLDivElement> & {
  size?: 'md' | 'sm';
  label?: string;
  children?: ReactNode;
};

export function ProgressBar({
  size = 'md',
  label = 'ProgressBar',
  children,
  className,
  ...rest
}: ProgressBarProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-size={size}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ProgressBar · DS React</p>
    </div>
  );
}
