import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { NavigationDrawerItem } from '../NavigationDrawerItem/NavigationDrawerItem';
import styles from './NavigationDrawer.module.css';

export type NavigationDrawerAppearance = 'default' | 'inverse';
export type NavigationDrawerItemCount = '3' | '4' | '5' | '6';

export type NavigationDrawerProps = HTMLAttributes<HTMLElement> & {
  heading?: string;
  appearance?: NavigationDrawerAppearance;
  itemCount?: NavigationDrawerItemCount;
  selectedIndex?: number;
  items?: string[];
};

const DEFAULTS = ['Home', 'Search', 'Inbox', 'Alerts', 'Settings', 'Help'];

export function NavigationDrawer({
  heading = 'Menu',
  appearance = 'default',
  itemCount = '4',
  selectedIndex = 0,
  items,
  className,
  ...rest
}: NavigationDrawerProps) {
  const count = Number(itemCount);
  const labels = Array.from({ length: count }, (_, i) => items?.[i] ?? DEFAULTS[i]);
  const split = count === 6 ? 4 : count;
  const primary = labels.slice(0, split);
  const secondary = labels.slice(split);

  return (
    <nav
      className={cx(styles.root, styles[`appearance-${appearance}`], className)}
      aria-label={heading}
      data-appearance={appearance}
      data-item-count={itemCount}
      {...rest}
    >
      <p className={styles.heading}>{heading}</p>
      <div className={styles.section}>
        {primary.map((label, index) => (
          <NavigationDrawerItem
            key={label}
            label={label}
            appearance={appearance}
            selected={index === selectedIndex}
          />
        ))}
      </div>
      {secondary.length > 0 && (
        <>
          <div className={styles.divider} aria-hidden />
          <div className={styles.section}>
            {secondary.map((label, index) => (
              <NavigationDrawerItem
                key={label}
                label={label}
                appearance={appearance}
                selected={split + index === selectedIndex}
              />
            ))}
          </div>
        </>
      )}
    </nav>
  );
}
