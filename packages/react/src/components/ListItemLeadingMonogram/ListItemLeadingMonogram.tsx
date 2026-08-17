import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListItemLeadingMonogram.module.css';

export type ListItemLeadingMonogramProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function ListItemLeadingMonogram({

  label = 'ListItemLeadingMonogram',
  children,
  className,
  ...rest
}: ListItemLeadingMonogramProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ListItemLeadingMonogram · DS React</p>
    </div>
  );
}
