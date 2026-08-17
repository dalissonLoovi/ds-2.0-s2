import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import { NavigationRailExpandedItem } from '../NavigationRailExpandedItem/NavigationRailExpandedItem';
import { NavigationRailExpandedTree } from '../NavigationRailExpandedTree/NavigationRailExpandedTree';
import styles from './NavigationRailExpanded.module.css';

export type NavigationRailExpandedAppearance = 'default' | 'inverse';
export type NavigationRailExpandedAlignment = 'top' | 'middle';
export type NavigationRailExpandedItemCount = '3' | '4' | '5' | '6';

export type NavigationRailExpandedProps = HTMLAttributes<HTMLElement> & {
  showMenu?: boolean;
  showButton?: boolean;
  showTree01?: boolean;
  showTree02?: boolean;
  showTree03?: boolean;
  showTree04?: boolean;
  showTree05?: boolean;
  appearance?: NavigationRailExpandedAppearance;
  alignment?: NavigationRailExpandedAlignment;
  itemCount?: NavigationRailExpandedItemCount;
  selectedIndex?: number;
  items?: string[];
  onMenu?: () => void;
  onPrimaryAction?: () => void;
};

const DEFAULTS = ['Home', 'Search', 'Inbox', 'Alerts', 'Settings', 'Help'];

export function NavigationRailExpanded({
  showMenu = true,
  showButton = true,
  showTree01 = false,
  showTree02 = false,
  showTree03 = false,
  showTree04 = false,
  showTree05 = false,
  appearance = 'default',
  alignment = 'top',
  itemCount = '4',
  selectedIndex = 0,
  items,
  onMenu,
  onPrimaryAction,
  className,
  ...rest
}: NavigationRailExpandedProps) {
  const count = Number(itemCount);
  const labels = Array.from({ length: count }, (_, i) => items?.[i] ?? DEFAULTS[i]);
  const trees = [showTree01, showTree02, showTree03, showTree04, showTree05];
  const allowTrees = alignment === 'top';

  return (
    <nav
      className={cx(
        styles.root,
        styles[`appearance-${appearance}`],
        styles[`alignment-${alignment}`],
        className,
      )}
      aria-label="Rail"
      data-appearance={appearance}
      data-alignment={alignment}
      data-item-count={itemCount}
      {...rest}
    >
      {showMenu && (
        <Button
          variant="text"
          size="lg"
          intent="primary"
          showLabel={false}
          showIcon
          icon="menu-2-outline"
          aria-label="Menu"
          onClick={onMenu}
        />
      )}
      <div className={styles.items}>
        {labels.map((label, index) =>
          allowTrees && trees[index] ? (
            <NavigationRailExpandedTree
              key={label}
              appearance={appearance}
              selectedItem={index === selectedIndex ? 'item-01' : 'none'}
            />
          ) : (
            <NavigationRailExpandedItem
              key={label}
              label={label}
              appearance={appearance}
              selected={index === selectedIndex}
            />
          ),
        )}
      </div>
      {showButton && (
        <Button
          variant="solid"
          size="md"
          intent="primary"
          showLabel
          label="Action"
          showIcon
          icon="plus-outline"
          aria-label="Primary action"
          onClick={onPrimaryAction}
        />
      )}
    </nav>
  );
}
