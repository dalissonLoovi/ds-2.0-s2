import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TabsSecondary.module.css';

export type TabsSecondaryProps = HTMLAttributes<HTMLDivElement> & {
  itemCount?: '2' | '3' | '4' | '5';
  platform?: 'web' | 'mobile';
  alignment?: 'left' | 'center';
  label?: string;
  children?: ReactNode;
};

export function TabsSecondary({
  itemCount = '2',
  platform = 'web',
  alignment = 'left',
  label = 'TabsSecondary',
  children,
  className,
  ...rest
}: TabsSecondaryProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-itemCount={itemCount}
      data-platform={platform}
      data-alignment={alignment}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TabsSecondary · DS React</p>
    </div>
  );
}
