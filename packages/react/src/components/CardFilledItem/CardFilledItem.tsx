import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './CardFilledItem.module.css';

export type CardFilledItemProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'enabled' | 'hover' | 'focus' | 'pressed' | 'dragged';
  label?: string;
  children?: ReactNode;
};

export function CardFilledItem({
  state = 'enabled',
  label = 'CardFilledItem',
  children,
  className,
  ...rest
}: CardFilledItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>CardFilledItem · DS React</p>
    </div>
  );
}
