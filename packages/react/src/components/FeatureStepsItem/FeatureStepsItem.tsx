import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './FeatureStepsItem.module.css';

export type FeatureStepsItemProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function FeatureStepsItem({

  label = 'FeatureStepsItem',
  children,
  className,
  ...rest
}: FeatureStepsItemProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>FeatureStepsItem · DS React</p>
    </div>
  );
}
