import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './NavigationRailExpandedItem.module.css';

export type NavigationRailExpandedItemProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: 'default' | 'inverse';
  state?: 'default' | 'hover' | 'focus' | 'pressed';
  hierarchy?: 'default' | 'nav-tree';
  badge?: 'none' | 'count' | 'dot';
  selected?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function NavigationRailExpandedItem({
  appearance = 'default',
  state = 'default',
  hierarchy = 'default',
  badge = 'none',
  selected = 'false',
  label = 'NavigationRailExpandedItem',
  children,
  className,
  ...rest
}: NavigationRailExpandedItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-appearance={appearance}
      data-state={state}
      data-hierarchy={hierarchy}
      data-badge={badge}
      data-selected={selected}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>NavigationRailExpandedItem · DS React</p>
    </div>
  );
}
