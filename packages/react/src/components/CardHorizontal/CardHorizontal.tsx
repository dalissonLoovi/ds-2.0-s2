import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './CardHorizontal.module.css';

export type CardHorizontalProps = HTMLAttributes<HTMLDivElement> & {
  style?: 'outlined' | 'elevated' | 'filled';
  layout?: 'media-and-text' | 'slot';
  label?: string;
  children?: ReactNode;
};

export function CardHorizontal({
  style = 'outlined',
  layout = 'media-and-text',
  label = 'CardHorizontal',
  children,
  className,
  ...rest
}: CardHorizontalProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-style={style}
      data-layout={layout}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>CardHorizontal · DS React</p>
    </div>
  );
}
