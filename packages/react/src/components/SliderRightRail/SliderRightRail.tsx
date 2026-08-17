import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SliderRightRail.module.css';

export type SliderRightRailProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function SliderRightRail({

  label = 'SliderRightRail',
  children,
  className,
  ...rest
}: SliderRightRailProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SliderRightRail · DS React</p>
    </div>
  );
}
