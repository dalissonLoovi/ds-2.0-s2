import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './InputSelect.module.css';

export type InputSelectProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'error' | 'disabled';
  content?: 'value' | 'placeholder' | 'label';
  leadingIcon?: 'true' | 'false';
  appearance?: 'default' | 'inverse';
  label?: string;
  children?: ReactNode;
};

export function InputSelect({
  state = 'default',
  content = 'value',
  leadingIcon = 'true',
  appearance = 'default',
  label = 'InputSelect',
  children,
  className,
  ...rest
}: InputSelectProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      data-content={content}
      data-leadingIcon={leadingIcon}
      data-appearance={appearance}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>InputSelect · DS React</p>
    </div>
  );
}
