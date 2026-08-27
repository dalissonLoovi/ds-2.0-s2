import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import styles from './LoadingSpinner.module.css';

export type LoadingSpinnerSize = 'xs' | 'sm' | 'md' | 'lg';

export type LoadingSpinnerProps = HTMLAttributes<HTMLDivElement> & {
  size?: LoadingSpinnerSize;
  /** When true, spinner is decorative (visible text already announces loading). */
  decorative?: boolean;
  label?: string;
};

/** Pixel map aligned to Figma LoadingSpinner size axis (lg|md|sm|xs). */
const SIZE_PX = { xs: 24, sm: 32, md: 64, lg: 80 } as const;

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
