import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './NavigationBarItem.module.css';

export type NavigationBarItemProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: 'default' | 'inverse';
  state?: 'default' | 'hover' | 'focus' | 'pressed';
  badge?: 'none' | 'count' | 'dot';
  selected?: 'false' | 'true';
  showLabel?: 'true' | 'false';
  label?: string;
  children?: ReactNode;
};

export function NavigationBarItem({
  appearance = 'default',
  state = 'default',
  badge = 'none',
  selected = 'false',
  showLabel = 'true',
  label = 'NavigationBarItem',
  children,
  className,
  ...rest
}: NavigationBarItemProps) {
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
      <p className={styles.meta}>NavigationBarItem · DS React</p>
    </div>
  );
}
