import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { StepProgressSegment, type StepProgressSegmentStatus } from '../StepProgressSegment/StepProgressSegment';
import styles from './StepProgressIndicator.module.css';

export type StepProgressIndicatorStepCount = '3' | '4' | '5' | '6' | '7' | '8';
export type StepProgressIndicatorCurrentStep = '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8';

export type StepProgressIndicatorProps = HTMLAttributes<HTMLDivElement> & {
  stepCount?: StepProgressIndicatorStepCount;
  currentStep?: StepProgressIndicatorCurrentStep;
  showCounter?: boolean;
  hasError?: boolean;
};

export function StepProgressIndicator({
  stepCount = '3',
  currentStep = '1',
  showCounter = true,
  hasError = false,
  className,
  ...rest
}: StepProgressIndicatorProps) {
  const total = Number(stepCount);
  const current = Math.min(Number(currentStep), total);

  return (
    <div
      className={cx(styles.root, className)}
      data-step-count={stepCount}
      data-current-step={String(current)}
      aria-label={`Etapa ${current} de ${total}`}
      {...rest}
    >
      {showCounter && (
        <p className={styles.counter}>
          Etapa {current} de {total}
        </p>
      )}
      <div className={styles.track}>
        {Array.from({ length: total }, (_, index) => {
          const step = index + 1;
          let status: StepProgressSegmentStatus = 'pending';
          if (step < current) status = 'completed';
          else if (step === current) status = hasError ? 'error' : 'current';
          return <StepProgressSegment key={step} status={status} />;
        })}
      </div>
    </div>
  );
}
