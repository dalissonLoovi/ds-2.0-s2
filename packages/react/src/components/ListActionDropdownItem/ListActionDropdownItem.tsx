import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListActionDropdownItem.module.css';

export type ListActionDropdownItemProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'pressed' | 'selected' | 'focus' | 'disabled';
  label?: string;
  children?: ReactNode;
};

export function ListActionDropdownItem({
  state = 'default',
  label = 'ListActionDropdownItem',
  children,
  className,
  ...rest
}: ListActionDropdownItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ListActionDropdownItem · DS React</p>
    </div>
  );
}
