import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './CardOutlinedItem.module.css';

export type CardOutlinedItemProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'enabled' | 'hover' | 'focus' | 'pressed' | 'dragged';
  label?: string;
  children?: ReactNode;
};

export function CardOutlinedItem({
  state = 'enabled',
  label = 'CardOutlinedItem',
  children,
  className,
  ...rest
}: CardOutlinedItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>CardOutlinedItem · DS React</p>
    </div>
  );
}
