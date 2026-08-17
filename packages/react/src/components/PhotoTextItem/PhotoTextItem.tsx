import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './PhotoTextItem.module.css';

export type PhotoTextItemProps = HTMLAttributes<HTMLDivElement> & {
  showSupportingText?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function PhotoTextItem({
  showSupportingText = 'false',
  label = 'PhotoTextItem',
  children,
  className,
  ...rest
}: PhotoTextItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-showSupportingText={showSupportingText}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>PhotoTextItem · DS React</p>
    </div>
  );
}
