import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import styles from './LoadingSpinner.module.css';

export type LoadingSpinnerSize = 'sm' | 'md' | 'lg';

export type LoadingSpinnerProps = HTMLAttributes<HTMLDivElement> & {
  size?: LoadingSpinnerSize;
  /** When true, spinner is decorative (visible text already announces loading). */
  decorative?: boolean;
  label?: string;
};

const SIZE_PX = { sm: 16, md: 24, lg: 40 } as const;

export function LoadingSpinner({
  size = 'md',
  decorative = false,
  label = 'Loading',
  className,
  ...rest
}: LoadingSpinnerProps) {
  const Icon = resolveIcon('loader-outline');

  return (
    <div
      className={cx(styles.root, styles[`size-${size}`], className)}
      role={decorative ? undefined : 'status'}
      aria-live={decorative ? undefined : 'polite'}
      aria-hidden={decorative || undefined}
      aria-label={decorative ? undefined : label}
      data-size={size}
      {...rest}
    >
      {Icon && <Icon size={SIZE_PX[size]} aria-hidden className={styles.icon} />}
    </div>
  );
}
