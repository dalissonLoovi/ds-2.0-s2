import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './NavigationDrawer.module.css';

export type NavigationDrawerProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: 'default' | 'inverse';
  itemCount?: '3' | '4' | '5' | '6';
  label?: string;
  children?: ReactNode;
};

export function NavigationDrawer({
  appearance = 'default',
  itemCount = '3',
  label = 'NavigationDrawer',
  children,
  className,
  ...rest
}: NavigationDrawerProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-appearance={appearance}
      data-itemCount={itemCount}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>NavigationDrawer · DS React</p>
    </div>
  );
}
