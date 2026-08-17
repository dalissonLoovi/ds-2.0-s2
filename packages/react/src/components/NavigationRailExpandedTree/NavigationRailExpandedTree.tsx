import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './NavigationRailExpandedTree.module.css';

export type NavigationRailExpandedTreeProps = HTMLAttributes<HTMLDivElement> & {
  selectedItem?: 'none' | 'item-01' | 'item-02' | 'item-03' | 'item-04';
  level?: 'default' | 'second-level';
  appearance?: 'default' | 'inverse';
  label?: string;
  children?: ReactNode;
};

export function NavigationRailExpandedTree({
  selectedItem = 'none',
  level = 'default',
  appearance = 'default',
  label = 'NavigationRailExpandedTree',
  children,
  className,
  ...rest
}: NavigationRailExpandedTreeProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-selectedItem={selectedItem}
      data-level={level}
      data-appearance={appearance}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>NavigationRailExpandedTree · DS React</p>
    </div>
  );
}
