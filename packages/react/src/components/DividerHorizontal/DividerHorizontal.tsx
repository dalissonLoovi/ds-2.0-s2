import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './DividerHorizontal.module.css';

export type DividerHorizontalVariant = 'full-width' | 'inset' | 'middle-inset' | 'with-subhead';

export type DividerHorizontalProps = HTMLAttributes<HTMLDivElement> & {
  variant?: DividerHorizontalVariant;
  label?: string;
  decorative?: boolean;
};

export function DividerHorizontal({
  variant = 'full-width',
  label = 'Label',
  decorative = true,
  className,
  ...rest
}: DividerHorizontalProps) {
  const showLabel = variant === 'with-subhead';
  return (
    <div
      className={cx(styles.root, styles[`variant-${variant}`], className)}
      role={decorative && !showLabel ? 'none' : 'separator'}
      aria-hidden={decorative && !showLabel || undefined}
      data-variant={variant}
      {...rest}
    >
      <span className={styles.line} />
      {showLabel && <span className={styles.label}>{label}</span>}
      {showLabel && <span className={styles.line} />}
    </div>
  );
}
