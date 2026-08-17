import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './DividerHorizontal.module.css';

export type DividerHorizontalProps = HTMLAttributes<HTMLDivElement> & {
  variant?: 'full-width' | 'inset' | 'middle-inset' | 'with-subhead';
  label?: string;
  children?: ReactNode;
};

export function DividerHorizontal({
  variant = 'full-width',
  label = 'DividerHorizontal',
  children,
  className,
  ...rest
}: DividerHorizontalProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-variant={variant}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>DividerHorizontal · DS React</p>
    </div>
  );
}
