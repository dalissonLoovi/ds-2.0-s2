import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './RadioButton.module.css';

export type RadioButtonProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'disabled';
  checked?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function RadioButton({
  state = 'default',
  checked = 'false',
  label = 'RadioButton',
  children,
  className,
  ...rest
}: RadioButtonProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      data-checked={checked}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>RadioButton · DS React</p>
    </div>
  );
}
