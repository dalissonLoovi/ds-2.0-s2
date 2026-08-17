import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './CardOutlinedItem.module.css';

export type CardOutlinedItemState = 'enabled' | 'hover' | 'focus' | 'pressed' | 'dragged';

export type CardOutlinedItemProps = HTMLAttributes<HTMLDivElement> & {
  state?: CardOutlinedItemState;
  showFocusIndicator?: boolean;
  children?: ReactNode;
};

export function CardOutlinedItem({
  state = 'enabled',
  showFocusIndicator = true,
  className,
  children,
  ...rest
}: CardOutlinedItemProps) {
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
