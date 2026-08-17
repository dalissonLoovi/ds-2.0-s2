import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './OfferProductCard.module.css';

export type OfferProductCardProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default';
  label?: string;
  children?: ReactNode;
};

export function OfferProductCard({
  state = 'default',
  label = 'OfferProductCard',
  children,
  className,
  ...rest
}: OfferProductCardProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>OfferProductCard · DS React</p>
    </div>
  );
}
