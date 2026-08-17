import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Checkbox.module.css';

export type CheckboxProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'focus' | 'disabled';
  checked?: 'false' | 'true' | 'mixed';
  label?: string;
  children?: ReactNode;
};

export function Checkbox({
  state = 'default',
  checked = 'false',
  label = 'Checkbox',
  children,
  className,
  ...rest
}: CheckboxProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      data-checked={checked}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Checkbox · DS React</p>
    </div>
  );
}
