import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListItemTrailingIllustration.module.css';

export type ListItemTrailingIllustrationProps = HTMLAttributes<HTMLSpanElement> & {
  /** Asset slug from Ilustrações e animações (any illustration/*; demo default sedan) */
  illustrationAsset?: string | null;
  /** Illustration node from the library — Figma INSTANCE_SWAP */
  illustration?: ReactNode;
};

/** Internal — ListItem trailing=illustration slot (any illustration/* INSTANCE_SWAP, 56×56; default base vehicle-icon/sedan). */
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
