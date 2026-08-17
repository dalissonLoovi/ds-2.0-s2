import { Children, type HTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import {
  CarouselPaginationItem,
  type CarouselPaginationItemCount,
  type CarouselPaginationItemView,
} from '../CarouselPaginationItem/CarouselPaginationItem';
import styles from './Carousel.module.css';

export type CarouselProps = HTMLAttributes<HTMLDivElement> & {
  showPaginationItem?: boolean;
  itemCount?: CarouselPaginationItemCount;
  itemView?: CarouselPaginationItemView;
  children?: ReactNode;
};

export function Carousel({
  showPaginationItem = true,
  itemCount = '4',
  itemView = '1',
  children,
  className,
  ...rest
}: CarouselProps) {
  const slides = Children.toArray(children);
  const count = Number(itemCount);
  const view = Math.min(Math.max(Number(itemView), 1), count);

  return (
    <div
      className={cx(styles.root, className)}
      aria-roledescription="carousel"
      data-item-count={itemCount}
      data-item-view={String(view)}
      {...rest}
    >
      <div className={styles.viewport}>
        {slides.length > 0
          ? slides.slice(0, count).map((child, index) => (
              <div key={index} className={styles.slide}>
                {child}
              </div>
            ))
          : Array.from({ length: count }, (_, index) => (
              <div key={index} className={cx(styles.slide, styles.placeholder)} />
            ))}
      </div>
      {showPaginationItem ? (
        <CarouselPaginationItem itemCount={itemCount} itemView={String(view) as CarouselPaginationItemView} />
      ) : null}
    </div>
  );
}
