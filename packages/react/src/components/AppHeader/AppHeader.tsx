import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './AppHeader.module.css';

export type AppHeaderProps = HTMLAttributes<HTMLDivElement> & {
  layout?: 'small-centered' | 'small' | 'medium' | 'large';
  appearance?: 'default' | 'inverse';
  hierarchy?: 'global' | 'specific' | 'super-app';
  label?: string;
  children?: ReactNode;
};

export function AppHeader({
  layout = 'small-centered',
  appearance = 'default',
  hierarchy = 'global',
  label = 'AppHeader',
  children,
  className,
  ...rest
}: AppHeaderProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-layout={layout}
      data-appearance={appearance}
      data-hierarchy={hierarchy}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>AppHeader · DS React</p>
    </div>
  );
}
