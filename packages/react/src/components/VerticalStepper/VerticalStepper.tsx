import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './VerticalStepper.module.css';

export type VerticalStepperProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function VerticalStepper({

  label = 'VerticalStepper',
  children,
  className,
  ...rest
}: VerticalStepperProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>VerticalStepper · DS React</p>
    </div>
  );
}
