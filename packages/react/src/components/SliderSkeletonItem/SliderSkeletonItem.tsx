import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SliderSkeletonItem.module.css';

export type SliderSkeletonItemProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function SliderSkeletonItem({

  label = 'SliderSkeletonItem',
  children,
  className,
  ...rest
}: SliderSkeletonItemProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SliderSkeletonItem · DS React</p>
    </div>
  );
}
