import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './CarouselPaginationItem.module.css';

export type CarouselPaginationItemProps = HTMLAttributes<HTMLDivElement> & {
  itemCount?: '2' | '3' | '4' | '5';
  itemView?: '1' | '2' | '3' | '4' | '5';
  label?: string;
  children?: ReactNode;
};

export function CarouselPaginationItem({
  itemCount = '2',
  itemView = '1',
  label = 'CarouselPaginationItem',
  children,
  className,
  ...rest
}: CarouselPaginationItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-itemCount={itemCount}
      data-itemView={itemView}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>CarouselPaginationItem · DS React</p>
    </div>
  );
}
