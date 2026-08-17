import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SelectCountry.module.css';

export type SelectCountryProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'disabled';
  size?: 'sm' | 'md';
  expanded?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function SelectCountry({
  state = 'default',
  size = 'sm',
  expanded = 'false',
  label = 'SelectCountry',
  children,
  className,
  ...rest
}: SelectCountryProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      data-size={size}
      data-expanded={expanded}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SelectCountry · DS React</p>
    </div>
  );
}
