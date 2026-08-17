import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './DividerVertical.module.css';

export type DividerVerticalProps = HTMLAttributes<HTMLDivElement> & {
  variant?: 'full-width' | 'inset' | 'middle-inset';
  label?: string;
  children?: ReactNode;
};

export function DividerVertical({
  variant = 'full-width',
  label = 'DividerVertical',
  children,
  className,
  ...rest
}: DividerVerticalProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-variant={variant}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>DividerVertical · DS React</p>
    </div>
  );
}
