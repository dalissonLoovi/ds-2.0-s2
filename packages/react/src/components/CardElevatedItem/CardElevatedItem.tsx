import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './CardElevatedItem.module.css';

export type CardElevatedItemState = 'enabled' | 'hover' | 'focus' | 'pressed' | 'dragged';

export type CardElevatedItemProps = HTMLAttributes<HTMLDivElement> & {
  state?: CardElevatedItemState;
  showFocusIndicator?: boolean;
  children?: ReactNode;
};

export function CardElevatedItem({
  state = 'enabled',
  showFocusIndicator = true,
  className,
  children,
  ...rest
}: CardElevatedItemProps) {
  return (
    <div
      className={cx(styles.root, styles[`state-${state}`], className)}
      data-state={state}
      {...rest}
    >
      <span
        className={cx(
          styles.stateLayer,
          state === 'hover' && styles.layerHover,
          state === 'dragged' && styles.layerDragged,
        )}
        aria-hidden
      />
      {state === 'focus' && showFocusIndicator ? <span className={styles.focusIndicator} aria-hidden /> : null}
      {children}
    </div>
  );
}
