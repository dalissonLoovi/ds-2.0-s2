import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './QuickAccessTile.module.css';

export type QuickAccessTileProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'pressed' | 'disabled';
  label?: string;
  children?: ReactNode;
};

export function QuickAccessTile({
  state = 'default',
  label = 'QuickAccessTile',
  children,
  className,
  ...rest
}: QuickAccessTileProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>QuickAccessTile · DS React</p>
    </div>
  );
}
