import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Switch.module.css';

export type SwitchProps = HTMLAttributes<HTMLDivElement> & {
  size?: 'md' | 'sm';
  state?: 'default' | 'focus' | 'disabled';
  checked?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function Switch({
  size = 'md',
  state = 'default',
  checked = 'false',
  label = 'Switch',
  children,
  className,
  ...rest
}: SwitchProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-size={size}
      data-state={state}
      data-checked={checked}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Switch · DS React</p>
    </div>
  );
}
