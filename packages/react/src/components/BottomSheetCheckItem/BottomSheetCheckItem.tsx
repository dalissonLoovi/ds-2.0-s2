import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './BottomSheetCheckItem.module.css';

export type BottomSheetCheckItemProps = HTMLAttributes<HTMLLIElement> & {
  description?: ReactNode;
  leadingIcon?: DsIconName | IconComponent | ReactNode;
};

export function BottomSheetCheckItem({
  description = 'Guideline description',
  leadingIcon = 'circle-check-filled',
  className,
  ...rest
}: BottomSheetCheckItemProps) {
  const Icon =
    typeof leadingIcon === 'string' || typeof leadingIcon === 'function'
      ? resolveIcon(leadingIcon as DsIconName | IconComponent)
      : null;

  return (
    <li className={cx(styles.root, className)} {...rest}>
      <span className={styles.icon} aria-hidden>
        {Icon ? <Icon size={20} /> : (leadingIcon as ReactNode)}
      </span>
      <span className={styles.description}>{description}</span>
    </li>
  );
}
