import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { SliderLeftRail } from '../SliderLeftRail/SliderLeftRail';
import { SliderRightRail } from '../SliderRightRail/SliderRightRail';
import styles from './SliderRail.module.css';

export type SliderRailProps = HTMLAttributes<HTMLSpanElement> & {
  active?: boolean;
  fillPercent?: number;
};

export function SliderRail({
  active = false,
  fillPercent = 40,
  className,
  ...rest
}: SliderRailProps) {
  const fill = Math.max(0, Math.min(100, fillPercent));

  return (
    <span className={cx(styles.root, className)} aria-hidden {...rest}>
      <SliderRightRail className={styles.right} />
      <SliderLeftRail active={active} className={styles.left} style={{ width: `${fill}%` }} />
    </span>
  );
}
