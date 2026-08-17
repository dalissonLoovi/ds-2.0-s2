import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './StepProgressSegment.module.css';

export type StepProgressSegmentStatus = 'completed' | 'current' | 'pending' | 'error';

export type StepProgressSegmentProps = HTMLAttributes<HTMLSpanElement> & {
  status?: StepProgressSegmentStatus;
};

export function StepProgressSegment({
  status = 'completed',
  className,
  ...rest
}: StepProgressSegmentProps) {
  return (
    <span
      className={cx(styles.root, styles[`status-${status}`], className)}
      data-status={status}
      aria-hidden
      {...rest}
    />
  );
}
