import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ChipGroup.module.css';

export type ChipGroupProps = HTMLAttributes<HTMLDivElement> & {
  type?: 'input' | 'assistive' | 'filter' | 'suggestion';
  layout?: 'single-row-scrollable' | 'multi-row-wrap';
  label?: string;
  children?: ReactNode;
};

export function ChipGroup({
  type = 'input',
  layout = 'single-row-scrollable',
  label = 'ChipGroup',
  children,
  className,
  ...rest
}: ChipGroupProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-type={type}
      data-layout={layout}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ChipGroup · DS React</p>
    </div>
  );
}
