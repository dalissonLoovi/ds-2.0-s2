import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './CarouselPaginationItem.module.css';

export type CarouselPaginationItemCount = '2' | '3' | '4' | '5';
export type CarouselPaginationItemView = '1' | '2' | '3' | '4' | '5';

export type CarouselPaginationItemProps = HTMLAttributes<HTMLDivElement> & {
  itemCount?: CarouselPaginationItemCount;
  itemView?: CarouselPaginationItemView;
};

export function CarouselPaginationItem({
  itemCount = '3',
  itemView = '1',
  className,
  ...rest
}: CarouselPaginationItemProps) {
  const count = Number(itemCount);
  const view = Math.min(Math.max(Number(itemView), 1), count);

  return (
    <div
      className={cx(styles.root, className)}
      data-item-count={itemCount}
      data-item-view={String(view)}
      aria-hidden
      {...rest}
    >
      {Array.from({ length: count }, (_, index) => (
        <span
          key={index}
          className={cx(styles.dot, index + 1 === view && styles.active)}
        />
      ))}
    </div>
  );
}
