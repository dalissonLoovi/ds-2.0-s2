import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListItemLeadingMonogram.module.css';

export type ListItemLeadingMonogramProps = HTMLAttributes<HTMLSpanElement> & {
  initial?: string;
};

export function ListItemLeadingMonogram({
  initial = 'A',
  className,
  ...rest
}: ListItemLeadingMonogramProps) {
  return (
    <span className={cx(styles.root, className)} aria-hidden {...rest}>
      {initial.slice(0, 1)}
    </span>
  );
}
