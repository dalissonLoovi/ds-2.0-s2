import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { SliderRail } from '../SliderRail/SliderRail';
import styles from './SliderItem.module.css';

export type SliderItemProps = HTMLAttributes<HTMLDivElement> & {
  active?: boolean;
  fillPercent?: number;
};

export function SliderItem({
  active = false,
  fillPercent = 40,
  className,
  ...rest
}: SliderItemProps) {
  return (
    <div className={cx(styles.root, className)} data-active={active} aria-hidden {...rest}>
      <span className={styles.tick} />
      <SliderRail active={active} fillPercent={fillPercent} />
    </div>
  );
}
