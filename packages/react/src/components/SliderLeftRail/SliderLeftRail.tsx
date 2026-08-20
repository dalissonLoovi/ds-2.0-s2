import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './SliderLeftRail.module.css';

export type SliderLeftRailProps = HTMLAttributes<HTMLSpanElement> & {
  active?: boolean;
};

export function SliderLeftRail({ active = false, className, style, ...rest }: SliderLeftRailProps) {
  return (
    <span
      className={cx(styles.root, active && styles.active, className)}
      data-active={active}
      style={style}
      aria-hidden
      {...rest}
    >
      <span className={styles.endCap} />
    </span>
  );
}
