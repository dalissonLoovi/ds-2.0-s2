import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Slider.module.css';

export type SliderProps = HTMLAttributes<HTMLDivElement> & {
  status?: 'enabled' | 'hover' | 'focus' | 'active' | 'error' | 'warning' | 'disabled' | 'read-only' | 'skeleton';
  label?: string;
  children?: ReactNode;
};

export function Slider({
  status = 'enabled',
  label = 'Slider',
  children,
  className,
  ...rest
}: SliderProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-status={status}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Slider · DS React</p>
    </div>
  );
}
