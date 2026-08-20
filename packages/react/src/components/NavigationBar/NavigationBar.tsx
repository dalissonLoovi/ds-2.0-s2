import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import { NavigationBarItem } from '../NavigationBarItem/NavigationBarItem';
import styles from './NavigationBar.module.css';

export type NavigationBarItemCount = '3' | '4' | '5';
export type NavigationBarAppearance = 'default' | 'inverse';
export type NavigationBarLayout = 'flush' | 'floating';

export type NavigationBarProps = HTMLAttributes<HTMLElement> & {
  itemCount?: NavigationBarItemCount;
  appearance?: NavigationBarAppearance;
  layout?: NavigationBarLayout;
  primaryLabel?: string;
  selectedIndex?: number;
  items?: Array<{ label: string; href?: string }>;
  onPrimaryAction?: () => void;
};

const DEFAULTS = ['Home', 'Search', 'Alerts', 'Profile'];

export function NavigationBar({
  itemCount = '4',
  appearance = 'default',
  layout = 'flush',
  primaryLabel = 'Acionar',
  selectedIndex = 0,
  items,
  onPrimaryAction,
  className,
  ...rest
}: NavigationBarProps) {
  const count = Number(itemCount);
  const destCount = count === 5 ? 4 : count;
  const destinations = Array.from({ length: destCount }, (_, i) => items?.[i]?.label ?? DEFAULTS[i]);

  return (
    <nav
      className={cx(
        styles.root,
        styles[`appearance-${appearance}`],
        styles[`layout-${layout}`],
        className,
      )}
      aria-label="Primary"
      data-item-count={itemCount}
      data-appearance={appearance}
      data-layout={layout}
      {...rest}
    >
      {destinations.map((label, index) => (
        <NavigationBarItem
          key={label}
          label={label}
          appearance={appearance}
          selected={index === selectedIndex}
        />
      ))}
      {count === 5 && (
        <div className={styles.fab}>
          <Button
            variant="solid"
            size="lg"
            intent="primary"
            showLabel={false}
            showIcon
            icon="plus-outline"
            aria-label={primaryLabel}
            onClick={onPrimaryAction}
            className={styles.fabButton}
          />
          <span className={styles.fabLabel}>{primaryLabel}</span>
        </div>
      )}
    </nav>
  );
}
