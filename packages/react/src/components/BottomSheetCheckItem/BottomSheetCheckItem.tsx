import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './BottomSheetCheckItem.module.css';

export type BottomSheetCheckItemProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function BottomSheetCheckItem({

  label = 'BottomSheetCheckItem',
  children,
  className,
  ...rest
}: BottomSheetCheckItemProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>BottomSheetCheckItem · DS React</p>
    </div>
  );
}
