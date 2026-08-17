import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Autocomplete.module.css';

export type AutocompleteProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'error' | 'disabled';
  content?: 'empty' | 'query' | 'selected';
  expanded?: 'false' | 'true';
  appearance?: 'default' | 'inverse';
  label?: string;
  children?: ReactNode;
};

export function Autocomplete({
  state = 'default',
  content = 'empty',
  expanded = 'false',
  appearance = 'default',
  label = 'Autocomplete',
  children,
  className,
  ...rest
}: AutocompleteProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      data-content={content}
      data-expanded={expanded}
      data-appearance={appearance}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Autocomplete · DS React</p>
    </div>
  );
}
