import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './ProgressBar.module.css';

export type ProgressBarSize = 'md' | 'sm';

export type ProgressBarProps = HTMLAttributes<HTMLDivElement> & {
  size?: ProgressBarSize;
  /** Numeric progress 0–100 used for the fill + aria-valuenow. */
  progress?: number;
  /** Visible value label (Figma `value` prop). Defaults to `${progress}%`. */
  value?: string;
  showValue?: boolean;
  label?: string;
};

export function ProgressBar({
  size = 'md',
  progress = 40,
  value,
  showValue = true,
  label = 'Progress',
  className,
  ...rest
}: ProgressBarProps) {
  const clamped = Math.max(0, Math.min(100, progress));
  const display = value ?? `${Math.round(clamped)}%`;

  return (
    <div
      className={cx(styles.root, styles[`size-${size}`], className)}
      data-size={size}
      {...rest}
    >
      <div
        className={styles.track}
        role="progressbar"
        aria-valuemin={0}
        aria-valuemax={100}
        aria-valuenow={clamped}
        aria-label={showValue ? undefined : label}
        aria-valuetext={showValue ? display : undefined}
      >
        <div className={styles.fill} style={{ width: `${clamped}%` }} />
      </div>
      {showValue && <span className={styles.value}>{display}</span>}
    </div>
  );
}
