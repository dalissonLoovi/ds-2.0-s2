import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './BottomSheet.module.css';

export type BottomSheetProps = HTMLAttributes<HTMLDivElement> & {
  header?: 'none' | 'sheet-header';
  label?: string;
  children?: ReactNode;
};

export function BottomSheet({
  header = 'none',
  label = 'BottomSheet',
  children,
  className,
  ...rest
}: BottomSheetProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-header={header}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>BottomSheet · DS React</p>
    </div>
  );
}
