import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './StepProgressIndicator.module.css';

export type StepProgressIndicatorProps = HTMLAttributes<HTMLDivElement> & {
  stepCount?: '3' | '4' | '5' | '6' | '7' | '8';
  currentStep?: '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8';
  label?: string;
  children?: ReactNode;
};

export function StepProgressIndicator({
  stepCount = '3',
  currentStep = '1',
  label = 'StepProgressIndicator',
  children,
  className,
  ...rest
}: StepProgressIndicatorProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-stepCount={stepCount}
      data-currentStep={currentStep}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>StepProgressIndicator · DS React</p>
    </div>
  );
}
