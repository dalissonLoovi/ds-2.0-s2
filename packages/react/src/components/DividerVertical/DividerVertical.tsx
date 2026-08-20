import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './DividerVertical.module.css';

export type DividerVerticalVariant = 'full-width' | 'inset' | 'middle-inset';

export type DividerVerticalProps = HTMLAttributes<HTMLDivElement> & {
  variant?: DividerVerticalVariant;
  decorative?: boolean;
};

export function DividerVertical({
  variant = 'full-width',
  decorative = true,
  className,
  ...rest
}: DividerVerticalProps) {
  return (
    <div
      className={cx(styles.root, styles[`variant-${variant}`], className)}
      role={decorative ? 'none' : 'separator'}
      aria-orientation={decorative ? undefined : 'vertical'}
      aria-hidden={decorative || undefined}
      data-variant={variant}
      {...rest}
    />
  );
}
