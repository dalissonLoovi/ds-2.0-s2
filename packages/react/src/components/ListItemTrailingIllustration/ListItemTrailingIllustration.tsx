import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListItemTrailingIllustration.module.css';

export type ListItemTrailingIllustrationProps = HTMLAttributes<HTMLSpanElement> & {
  /** Asset slug e.g. sedan | van | suv (illustration/vehicle-icon/*) */
  illustrationAsset?: string | null;
  illustration?: ReactNode;
};

/** Internal — ListItem trailing=illustration slot (illustration/* INSTANCE_SWAP, 56×56). */
export function ListItemTrailingIllustration({
  illustrationAsset = 'sedan',
  illustration,
  className,
  ...rest
}: ListItemTrailingIllustrationProps) {
  if (illustration != null) {
    return (
      <span className={cx(styles.root, className)} aria-hidden {...rest}>
        {illustration}
      </span>
    );
  }

  return (
    <span
      className={cx(styles.root, className)}
      data-asset={illustrationAsset ?? undefined}
      aria-hidden
      {...rest}
    />
  );
}
