import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './CardElevatedItem.module.css';

export type CardElevatedItemProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'enabled' | 'hover' | 'focus' | 'pressed' | 'dragged';
  label?: string;
  children?: ReactNode;
};

export function CardElevatedItem({
  state = 'enabled',
  label = 'CardElevatedItem',
  children,
  className,
  ...rest
}: CardElevatedItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>CardElevatedItem · DS React</p>
    </div>
  );
}
