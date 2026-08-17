import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TabsPrimary.module.css';

export type TabsPrimaryProps = HTMLAttributes<HTMLDivElement> & {
  itemCount?: '2' | '3' | '4' | '5';
  platform?: 'web' | 'mobile';
  alignment?: 'left' | 'center';
  appearance?: 'default' | 'inverse';
  label?: string;
  children?: ReactNode;
};

export function TabsPrimary({
  itemCount = '2',
  platform = 'web',
  alignment = 'left',
  appearance = 'default',
  label = 'TabsPrimary',
  children,
  className,
  ...rest
}: TabsPrimaryProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-itemCount={itemCount}
      data-platform={platform}
      data-alignment={alignment}
      data-appearance={appearance}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TabsPrimary · DS React</p>
    </div>
  );
}
