import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './VehicleSummaryCard.module.css';

export type VehicleSummaryCardProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: 'default' | 'secondary';
  status?: 'active' | 'inactive';
  label?: string;
  children?: ReactNode;
};

export function VehicleSummaryCard({
  appearance = 'default',
  status = 'active',
  label = 'VehicleSummaryCard',
  children,
  className,
  ...rest
}: VehicleSummaryCardProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-appearance={appearance}
      data-status={status}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>VehicleSummaryCard · DS React</p>
    </div>
  );
}
