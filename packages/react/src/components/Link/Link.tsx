import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Link.module.css';

export type LinkProps = HTMLAttributes<HTMLDivElement> & {
  size?: 'lg' | 'md' | 'sm';
  state?: 'default' | 'hover' | 'focus' | 'active' | 'visited' | 'disabled';
  appearance?: 'default' | 'inverse';
  label?: string;
  children?: ReactNode;
};

export function Link({
  size = 'lg',
  state = 'default',
  appearance = 'default',
  label = 'Link',
  children,
  className,
  ...rest
}: LinkProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-size={size}
      data-state={state}
      data-appearance={appearance}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Link · DS React</p>
    </div>
  );
}
