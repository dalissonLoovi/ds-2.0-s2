import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { SliderItem } from '../SliderItem/SliderItem';
import styles from './SliderSkeletonItem.module.css';

export type SliderSkeletonItemProps = HTMLAttributes<HTMLDivElement>;

export function SliderSkeletonItem({ className, ...rest }: SliderSkeletonItemProps) {
  return (
    <div className={cx(styles.root, className)} aria-hidden {...rest}>
      <span className={cx(styles.bone, styles.labelBone)} />
      <div className={styles.sliderRow}>
        <span className={cx(styles.bone, styles.valueBone)} />
        <SliderItem active={false} fillPercent={40} className={styles.item} />
        <span className={cx(styles.bone, styles.valueBone)} />
      </div>
    </div>
  );
}
