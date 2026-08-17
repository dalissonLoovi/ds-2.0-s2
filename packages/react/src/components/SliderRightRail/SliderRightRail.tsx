import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './SliderRightRail.module.css';

export type SliderRightRailProps = HTMLAttributes<HTMLSpanElement>;

export function SliderRightRail({ className, ...rest }: SliderRightRailProps) {
  return <span className={cx(styles.root, className)} aria-hidden {...rest} />;
}
