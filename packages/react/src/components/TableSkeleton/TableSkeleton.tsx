import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './TableSkeleton.module.css';

export type TableSkeletonProps = HTMLAttributes<HTMLDivElement> & {
  empty?: boolean;
};

const COLUMNS = 5;
const BODY_ROWS = 6;

export function TableSkeleton({ empty = false, className, ...rest }: TableSkeletonProps) {
  return (
    <div
      className={cx(styles.root, empty && styles.empty, className)}
      data-empty={empty}
      aria-busy
      aria-label="Loading table"
      {...rest}
    >
      <div className={styles.header} aria-hidden>
        {Array.from({ length: COLUMNS }, (_, index) => (
          <span key={`h-${index}`} className={cx(styles.bar, styles.headerBar)} />
        ))}
      </div>
      {!empty &&
        Array.from({ length: BODY_ROWS }, (_, row) => (
          <div key={`r-${row}`} className={styles.row} aria-hidden>
            {Array.from({ length: COLUMNS }, (_, col) => (
              <span key={`c-${row}-${col}`} className={styles.bar} />
            ))}
          </div>
        ))}
    </div>
  );
}
