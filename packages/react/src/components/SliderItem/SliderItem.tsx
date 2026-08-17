import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SliderItem.module.css';

export type SliderItemProps = HTMLAttributes<HTMLDivElement> & {
  active?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function SliderItem({
  active = 'false',
  label = 'SliderItem',
  children,
  className,
  ...rest
}: SliderItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-active={active}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SliderItem · DS React</p>
    </div>
  );
}
