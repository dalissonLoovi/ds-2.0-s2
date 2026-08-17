import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './RadioButtonCard.module.css';

export type RadioButtonCardProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'disabled';
  checked?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function RadioButtonCard({
  state = 'default',
  checked = 'false',
  label = 'RadioButtonCard',
  children,
  className,
  ...rest
}: RadioButtonCardProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      data-checked={checked}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>RadioButtonCard · DS React</p>
    </div>
  );
}
