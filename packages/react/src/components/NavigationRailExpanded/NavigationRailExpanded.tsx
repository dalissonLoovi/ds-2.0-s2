import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './NavigationRailExpanded.module.css';

export type NavigationRailExpandedProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: 'default' | 'inverse';
  alignment?: 'top' | 'middle';
  itemCount?: '3' | '4' | '5' | '6';
  label?: string;
  children?: ReactNode;
};

export function NavigationRailExpanded({
  appearance = 'default',
  alignment = 'top',
  itemCount = '3',
  label = 'NavigationRailExpanded',
  children,
  className,
  ...rest
}: NavigationRailExpandedProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-appearance={appearance}
      data-alignment={alignment}
      data-itemCount={itemCount}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>NavigationRailExpanded · DS React</p>
    </div>
  );
}
