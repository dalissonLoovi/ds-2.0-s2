import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './ModalCheckItem.module.css';

export type ModalCheckItemProps = HTMLAttributes<HTMLDivElement> & {
  leadingIcon?: DsIconName | IconComponent | ReactNode;
  description?: ReactNode;
};

export function ModalCheckItem({
  leadingIcon = 'circle-check-filled',
  description = (
    <>
      Avoid wearing <strong>glasses, hats or accessories</strong> in the photo.
    </>
  ),
  className,
  ...rest
}: ModalCheckItemProps) {
  const Icon =
    typeof leadingIcon === 'string' || typeof leadingIcon === 'function'
      ? resolveIcon(leadingIcon as DsIconName | IconComponent)
      : null;

  return (
    <div className={cx(styles.root, className)} {...rest}>
      <span className={styles.icon} aria-hidden>
        {Icon ? <Icon size={20} /> : (leadingIcon as ReactNode)}
      </span>
      <p className={styles.description}>{description}</p>
    </div>
  );
}
