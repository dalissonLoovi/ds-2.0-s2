import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SliderLeftRail.module.css';

export type SliderLeftRailProps = HTMLAttributes<HTMLDivElement> & {
  active?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function SliderLeftRail({
  active = 'false',
  label = 'SliderLeftRail',
  children,
  className,
  ...rest
}: SliderLeftRailProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-active={active}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SliderLeftRail · DS React</p>
    </div>
  );
}
