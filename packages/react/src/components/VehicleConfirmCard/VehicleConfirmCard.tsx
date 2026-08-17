import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './VehicleConfirmCard.module.css';

export type VehicleConfirmCardProps = HTMLAttributes<HTMLElement> & {
  plate?: string;
  brandModel?: string;
};

export function VehicleConfirmCard({
  plate = 'ABC1D23',
  brandModel = 'Brand Model',
  className,
  ...rest
}: VehicleConfirmCardProps) {
  return (
    <article className={cx(styles.root, className)} {...rest}>
      <div className={styles.topo} aria-hidden>
        <span className={styles.handle} />
      </div>
      <div className={styles.text}>
        <p className={styles.plate}>{plate}</p>
        <p className={styles.brandModel}>{brandModel}</p>
      </div>
    </article>
  );
}
