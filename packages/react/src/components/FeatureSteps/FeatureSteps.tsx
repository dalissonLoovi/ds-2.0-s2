import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './FeatureSteps.module.css';

export type FeatureStepsProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function FeatureSteps({

  label = 'FeatureSteps',
  children,
  className,
  ...rest
}: FeatureStepsProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>FeatureSteps · DS React</p>
    </div>
  );
}
