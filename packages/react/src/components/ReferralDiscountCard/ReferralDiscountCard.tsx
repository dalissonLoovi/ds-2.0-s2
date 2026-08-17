import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ReferralDiscountCard.module.css';

export type ReferralDiscountCardProps = HTMLAttributes<HTMLDivElement> & {
  mode?: 'status' | 'simulator' | 'fleet';
  label?: string;
  children?: ReactNode;
};

export function ReferralDiscountCard({
  mode = 'status',
  label = 'ReferralDiscountCard',
  children,
  className,
  ...rest
}: ReferralDiscountCardProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-mode={mode}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ReferralDiscountCard · DS React</p>
    </div>
  );
}
