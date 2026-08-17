import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Carousel.module.css';

export type CarouselProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function Carousel({

  label = 'Carousel',
  children,
  className,
  ...rest
}: CarouselProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Carousel · DS React</p>
    </div>
  );
}
