import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './BottomSheetHeader.module.css';

export type BottomSheetHeaderProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: 'default';
  label?: string;
  children?: ReactNode;
};

export function BottomSheetHeader({
  appearance = 'default',
  label = 'BottomSheetHeader',
  children,
  className,
  ...rest
}: BottomSheetHeaderProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-appearance={appearance}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>BottomSheetHeader · DS React</p>
    </div>
  );
}
