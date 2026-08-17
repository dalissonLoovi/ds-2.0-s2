import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './NavigationRailCompactItem.module.css';

export type NavigationRailCompactItemProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: 'default' | 'inverse';
  state?: 'default' | 'hover' | 'focus' | 'pressed';
  badge?: 'none' | 'count' | 'dot';
  selected?: 'false' | 'true';
  showLabel?: 'true' | 'false';
  label?: string;
  children?: ReactNode;
};

export function NavigationRailCompactItem({
  appearance = 'default',
  state = 'default',
  badge = 'none',
  selected = 'false',
  showLabel = 'true',
  label = 'NavigationRailCompactItem',
  children,
  className,
  ...rest
}: NavigationRailCompactItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-appearance={appearance}
      data-state={state}
      data-badge={badge}
      data-selected={selected}
      data-showLabel={showLabel}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>NavigationRailCompactItem · DS React</p>
    </div>
  );
}
