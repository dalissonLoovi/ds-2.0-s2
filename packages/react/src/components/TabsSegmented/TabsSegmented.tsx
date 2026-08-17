import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TabsSegmented.module.css';

export type TabsSegmentedProps = HTMLAttributes<HTMLDivElement> & {
  itemCount?: '2' | '3' | '4' | '5';
  platform?: 'web' | 'mobile';
  alignment?: 'left' | 'center';
  label?: string;
  children?: ReactNode;
};

export function TabsSegmented({
  itemCount = '2',
  platform = 'web',
  alignment = 'left',
  label = 'TabsSegmented',
  children,
  className,
  ...rest
}: TabsSegmentedProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-itemCount={itemCount}
      data-platform={platform}
      data-alignment={alignment}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TabsSegmented · DS React</p>
    </div>
  );
}
