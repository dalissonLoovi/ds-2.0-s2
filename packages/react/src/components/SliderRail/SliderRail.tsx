import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SliderRail.module.css';

export type SliderRailProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function SliderRail({

  label = 'SliderRail',
  children,
  className,
  ...rest
}: SliderRailProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SliderRail · DS React</p>
    </div>
  );
}
