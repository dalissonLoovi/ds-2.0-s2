import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Overlay.module.css';

export type OverlayProps = HTMLAttributes<HTMLDivElement> & {
  type?: 'modal' | 'bottom-sheet';
  platform?: 'mobile' | 'web';
  label?: string;
  children?: ReactNode;
};

export function Overlay({
  type = 'modal',
  platform = 'mobile',
  label = 'Overlay',
  children,
  className,
  ...rest
}: OverlayProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-type={type}
      data-platform={platform}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Overlay · DS React</p>
    </div>
  );
}
