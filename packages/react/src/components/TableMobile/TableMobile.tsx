import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TableMobile.module.css';

export type TableMobileProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'pressed';
  interactive?: 'false' | 'true';
  showTag?: 'true' | 'false';
  columnCount?: '2' | '3' | '4' | '5' | '6';
  label?: string;
  children?: ReactNode;
};

export function TableMobile({
  state = 'default',
  interactive = 'false',
  showTag = 'true',
  columnCount = '2',
  label = 'TableMobile',
  children,
  className,
  ...rest
}: TableMobileProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      data-interactive={interactive}
      data-showTag={showTag}
      data-columnCount={columnCount}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TableMobile · DS React</p>
    </div>
  );
}
