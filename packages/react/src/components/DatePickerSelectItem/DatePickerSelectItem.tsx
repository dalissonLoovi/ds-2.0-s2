import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './DatePickerSelectItem.module.css';

export type DatePickerSelectItemProps = HTMLAttributes<HTMLDivElement> & {
  unit?: 'day' | 'month' | 'year';
  state?: 'default' | 'hover' | 'focus' | 'disabled';
  expanded?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function DatePickerSelectItem({
  unit = 'day',
  state = 'default',
  expanded = 'false',
  label = 'DatePickerSelectItem',
  children,
  className,
  ...rest
}: DatePickerSelectItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-unit={unit}
      data-state={state}
      data-expanded={expanded}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>DatePickerSelectItem · DS React</p>
    </div>
  );
}
