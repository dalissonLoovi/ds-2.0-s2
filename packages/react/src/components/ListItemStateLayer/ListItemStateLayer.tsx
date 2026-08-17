import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListItemStateLayer.module.css';

export type ListItemStateLayerState = 'default' | 'hover' | 'focus' | 'pressed' | 'dragged';

export type ListItemStateLayerProps = HTMLAttributes<HTMLSpanElement> & {
  state?: ListItemStateLayerState;
};

export function ListItemStateLayer({
  state = 'default',
  className,
  ...rest
}: ListItemStateLayerProps) {
  return (
    <span
      className={cx(styles.root, styles[`state-${state}`], className)}
      data-state={state}
      aria-hidden
      {...rest}
    />
  );
}
