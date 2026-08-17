import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './NavigationDrawerItem.module.css';

export type NavigationDrawerItemProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: 'default' | 'inverse';
  state?: 'default' | 'hover' | 'focus' | 'pressed';
  selected?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function NavigationDrawerItem({
  appearance = 'default',
  state = 'default',
  selected = 'false',
  label = 'NavigationDrawerItem',
  children,
  className,
  ...rest
}: NavigationDrawerItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-appearance={appearance}
      data-state={state}
      data-selected={selected}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>NavigationDrawerItem · DS React</p>
    </div>
  );
}
