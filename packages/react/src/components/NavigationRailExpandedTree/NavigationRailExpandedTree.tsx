import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { NavigationRailExpandedItem } from '../NavigationRailExpandedItem/NavigationRailExpandedItem';
import styles from './NavigationRailExpandedTree.module.css';

export type NavigationRailExpandedTreeSelectedItem =
  | 'none'
  | 'item-01'
  | 'item-02'
  | 'item-03'
  | 'item-04';
export type NavigationRailExpandedTreeLevel = 'default' | 'second-level';
export type NavigationRailExpandedTreeAppearance = 'default' | 'inverse';

export type NavigationRailExpandedTreeProps = HTMLAttributes<HTMLDivElement> & {
  selectedItem?: NavigationRailExpandedTreeSelectedItem;
  level?: NavigationRailExpandedTreeLevel;
  appearance?: NavigationRailExpandedTreeAppearance;
  parentLabel?: string;
  childLabels?: string[];
};

const CHILDREN = ['Overview', 'Reports', 'Settings', 'Archive'];

export function NavigationRailExpandedTree({
  selectedItem = 'none',
  level = 'default',
  appearance = 'default',
  parentLabel = 'Workspace',
  childLabels = CHILDREN,
  className,
  ...rest
}: NavigationRailExpandedTreeProps) {
  const selectedIndex =
    selectedItem === 'none' ? -1 : Number(selectedItem.replace('item-0', '')) - 1;
  const nested = level === 'second-level';
  const visibleChildren = nested ? childLabels.slice(0, 3) : [];

  return (
    <div
      className={cx(styles.root, styles[`appearance-${appearance}`], className)}
      data-selected-item={selectedItem}
      data-level={level}
      data-appearance={appearance}
      {...rest}
    >
      <NavigationRailExpandedItem
        label={parentLabel}
        appearance={appearance}
        hierarchy="nav-tree"
        selected={selectedItem !== 'none' && !nested}
      />
      {nested && (
        <div className={styles.children} role="group" aria-label={parentLabel}>
          <span className={styles.rail} aria-hidden />
          {visibleChildren.map((label, index) => (
            <NavigationRailExpandedItem
              key={label}
              label={label}
              appearance={appearance}
              selected={index === selectedIndex}
            />
          ))}
        </div>
      )}
    </div>
  );
}
