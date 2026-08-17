import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './StepProgressSegment.module.css';

export type StepProgressSegmentProps = HTMLAttributes<HTMLDivElement> & {
  status?: 'completed' | 'current' | 'pending' | 'error';
  label?: string;
  children?: ReactNode;
};

export function StepProgressSegment({
  status = 'completed',
  label = 'StepProgressSegment',
  children,
  className,
  ...rest
}: StepProgressSegmentProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-status={status}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>StepProgressSegment · DS React</p>
    </div>
  );
}
