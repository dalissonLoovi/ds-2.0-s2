import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SystemHeader.module.css';

export type SystemHeaderProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: 'default' | 'inverse';
  variant?: 'default' | 'simple';
  label?: string;
  children?: ReactNode;
};

export function SystemHeader({
  appearance = 'default',
  variant = 'default',
  label = 'SystemHeader',
  children,
  className,
  ...rest
}: SystemHeaderProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-appearance={appearance}
      data-variant={variant}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SystemHeader · DS React</p>
    </div>
  );
}
