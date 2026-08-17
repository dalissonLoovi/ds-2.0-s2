import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './InputDatePicker.module.css';

export type InputDatePickerProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'error' | 'disabled';
  content?: 'value' | 'placeholder' | 'label';
  leadingIcon?: 'true' | 'false';
  appearance?: 'default' | 'inverse';
  label?: string;
  children?: ReactNode;
};

export function InputDatePicker({
  state = 'default',
  content = 'value',
  leadingIcon = 'true',
  appearance = 'default',
  label = 'InputDatePicker',
  children,
  className,
  ...rest
}: InputDatePickerProps) {
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
      <p className={styles.meta}>InputDatePicker · DS React</p>
    </div>
  );
}
