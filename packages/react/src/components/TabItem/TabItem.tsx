import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TabItem.module.css';

export type TabItemProps = HTMLAttributes<HTMLDivElement> & {
  variant?: 'primary' | 'secondary' | 'segmented';
  state?: 'default' | 'hover' | 'selected' | 'disabled';
  platform?: 'web' | 'mobile';
  appearance?: 'default' | 'inverse';
  label?: string;
  children?: ReactNode;
};

export function TabItem({
  variant = 'primary',
  state = 'default',
  platform = 'web',
  appearance = 'default',
  label = 'TabItem',
  children,
  className,
  ...rest
}: TabItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-variant={variant}
      data-state={state}
      data-platform={platform}
      data-appearance={appearance}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TabItem · DS React</p>
    </div>
  );
}
