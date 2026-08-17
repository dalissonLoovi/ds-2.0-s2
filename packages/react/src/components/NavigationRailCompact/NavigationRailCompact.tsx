import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import { NavigationRailCompactItem } from '../NavigationRailCompactItem/NavigationRailCompactItem';
import styles from './NavigationRailCompact.module.css';

export type NavigationRailCompactAppearance = 'default' | 'inverse';
export type NavigationRailCompactAlignment = 'top' | 'middle';
export type NavigationRailCompactItemCount = '3' | '4' | '5' | '6';

export type NavigationRailCompactProps = HTMLAttributes<HTMLElement> & {
  showMenu?: boolean;
  showButton?: boolean;
  appearance?: NavigationRailCompactAppearance;
  alignment?: NavigationRailCompactAlignment;
  itemCount?: NavigationRailCompactItemCount;
  selectedIndex?: number;
  items?: string[];
  onMenu?: () => void;
  onPrimaryAction?: () => void;
};

const DEFAULTS = ['Home', 'Search', 'Inbox', 'Alerts', 'Settings', 'Help'];

export function NavigationRailCompact({
  showMenu = true,
  showButton = true,
  appearance = 'default',
  alignment = 'top',
  itemCount = '4',
  selectedIndex = 0,
  items,
  onMenu,
  onPrimaryAction,
  className,
  ...rest
}: NavigationRailCompactProps) {
  const count = Number(itemCount);
  const labels = Array.from({ length: count }, (_, i) => items?.[i] ?? DEFAULTS[i]);

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
        {labels.map((label, index) => (
          <NavigationRailCompactItem
            key={label}
            label={label}
            appearance={appearance}
            selected={index === selectedIndex}
          />
        ))}
      </div>
      {showButton && (
        <Button
          variant="solid"
          size="md"
          intent="primary"
          showLabel={false}
          showIcon
          icon="plus-outline"
          aria-label="Primary action"
          onClick={onPrimaryAction}
        />
      )}
    </nav>
  );
}
