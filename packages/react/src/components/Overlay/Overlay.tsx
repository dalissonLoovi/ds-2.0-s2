import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Overlay.module.css';

export type OverlayType = 'modal' | 'bottom-sheet';
export type OverlayPlatform = 'mobile' | 'web';

export type OverlayProps = HTMLAttributes<HTMLDivElement> & {
  type?: OverlayType;
  platform?: OverlayPlatform;
  /** Prefer nesting Modal or BottomSheet as children (seed slot). */
  children?: ReactNode;
  open?: boolean;
};

export function Overlay({
  type = 'modal',
  platform = 'mobile',
  open = true,
  children,
  className,
  ...rest
}: OverlayProps) {
  if (!open) return null;

  // Seed sparse matrix: do not use type=bottom-sheet with platform=web.
  const sparseInvalid = type === 'bottom-sheet' && platform === 'web';
  if (sparseInvalid) {
    // Keep render for Storybook demos, but mark invalid combo for consumers.
  }

  return (
    <div
      className={cx(
        styles.root,
        styles[`type-${type}`],
        styles[`platform-${platform}`],
        sparseInvalid && styles.sparseInvalid,
        className,
      )}
      data-type={type}
      data-platform={platform}
      data-sparse-invalid={sparseInvalid || undefined}
      role="presentation"
      {...rest}
    >
      <div className={styles.scrim} aria-hidden />
      <div className={styles.slot}>{children}</div>
    </div>
  );
}
