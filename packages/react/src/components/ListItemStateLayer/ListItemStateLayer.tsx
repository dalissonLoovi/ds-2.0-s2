import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListItemStateLayer.module.css';

export type ListItemStateLayerProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'pressed' | 'dragged';
  label?: string;
  children?: ReactNode;
};

export function ListItemStateLayer({
  state = 'default',
  label = 'ListItemStateLayer',
  children,
  className,
  ...rest
}: ListItemStateLayerProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ListItemStateLayer · DS React</p>
    </div>
  );
}
