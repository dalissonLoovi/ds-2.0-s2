import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './NavigationBar.module.css';

export type NavigationBarProps = HTMLAttributes<HTMLDivElement> & {
  itemCount?: '3' | '4' | '5';
  appearance?: 'default' | 'inverse';
  layout?: 'flush' | 'floating';
  label?: string;
  children?: ReactNode;
};

export function NavigationBar({
  itemCount = '3',
  appearance = 'default',
  layout = 'flush',
  label = 'NavigationBar',
  children,
  className,
  ...rest
}: NavigationBarProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-itemCount={itemCount}
      data-appearance={appearance}
      data-layout={layout}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>NavigationBar · DS React</p>
    </div>
  );
}
