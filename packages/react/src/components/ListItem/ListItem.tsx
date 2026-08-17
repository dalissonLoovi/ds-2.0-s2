import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListItem.module.css';

export type ListItemProps = HTMLAttributes<HTMLDivElement> & {
  condition?: '1-line' | '2-line' | '3-line';
  leading?: 'none' | 'monogram' | 'icon' | 'image' | 'video' | 'checkbox' | 'radio' | 'switch';
  trailing?: 'none' | 'icon' | 'checkbox' | 'radio' | 'switch';
  showOverline?: 'false' | 'true';
  showSupportingText?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function ListItem({
  condition = '1-line',
  leading = 'none',
  trailing = 'none',
  showOverline = 'false',
  showSupportingText = 'false',
  label = 'ListItem',
  children,
  className,
  ...rest
}: ListItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-condition={condition}
      data-leading={leading}
      data-trailing={trailing}
      data-showOverline={showOverline}
      data-showSupportingText={showSupportingText}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ListItem · DS React</p>
    </div>
  );
}
