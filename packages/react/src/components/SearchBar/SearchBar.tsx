import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SearchBar.module.css';

export type SearchBarProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'pressed' | 'disabled';
  content?: 'placeholder' | 'value';
  label?: string;
  children?: ReactNode;
};

export function SearchBar({
  state = 'default',
  content = 'placeholder',
  label = 'SearchBar',
  children,
  className,
  ...rest
}: SearchBarProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      data-content={content}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SearchBar · DS React</p>
    </div>
  );
}
