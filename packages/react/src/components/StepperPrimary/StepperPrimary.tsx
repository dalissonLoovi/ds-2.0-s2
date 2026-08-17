import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './StepperPrimary.module.css';

export type StepperPrimaryProps = HTMLAttributes<HTMLDivElement> & {
  status?: 'completed' | 'current' | 'pending';
  trail?: 'both' | 'left' | 'right';
  trailState?: 'none' | 'both' | 'left' | 'right';
  label?: string;
  children?: ReactNode;
};

export function StepperPrimary({
  status = 'completed',
  trail = 'both',
  trailState = 'none',
  label = 'StepperPrimary',
  children,
  className,
  ...rest
}: StepperPrimaryProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-status={status}
      data-trail={trail}
      data-trailState={trailState}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>StepperPrimary · DS React</p>
    </div>
  );
}
