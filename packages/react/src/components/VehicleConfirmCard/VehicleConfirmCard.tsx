import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './VehicleConfirmCard.module.css';

export type VehicleConfirmCardProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function VehicleConfirmCard({

  label = 'VehicleConfirmCard',
  children,
  className,
  ...rest
}: VehicleConfirmCardProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>VehicleConfirmCard · DS React</p>
    </div>
  );
}
