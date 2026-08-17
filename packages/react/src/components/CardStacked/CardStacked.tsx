import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './CardStacked.module.css';

export type CardStackedProps = HTMLAttributes<HTMLDivElement> & {
  style?: 'outlined' | 'elevated' | 'filled';
  layout?: 'media-and-text' | 'slot';
  label?: string;
  children?: ReactNode;
};

export function CardStacked({
  style = 'outlined',
  layout = 'media-and-text',
  label = 'CardStacked',
  children,
  className,
  ...rest
}: CardStackedProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-style={style}
      data-layout={layout}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>CardStacked · DS React</p>
    </div>
  );
}
