import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './VerticalStepperItem.module.css';

export type VerticalStepperItemProps = HTMLAttributes<HTMLDivElement> & {
  status?: 'completed' | 'current' | 'pending' | 'error';
  label?: string;
  children?: ReactNode;
};

export function VerticalStepperItem({
  status = 'completed',
  label = 'VerticalStepperItem',
  children,
  className,
  ...rest
}: VerticalStepperItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-status={status}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>VerticalStepperItem · DS React</p>
    </div>
  );
}
