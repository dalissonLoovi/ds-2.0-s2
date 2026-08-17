import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './CardFilledItem.module.css';

export type CardFilledItemState = 'enabled' | 'hover' | 'focus' | 'pressed' | 'dragged';

export type CardFilledItemProps = HTMLAttributes<HTMLDivElement> & {
  state?: CardFilledItemState;
  showFocusIndicator?: boolean;
  children?: ReactNode;
};

export function CardFilledItem({
  state = 'enabled',
  showFocusIndicator = true,
  className,
  children,
  ...rest
}: CardFilledItemProps) {
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
