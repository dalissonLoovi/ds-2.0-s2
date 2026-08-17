import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './InputNumber.module.css';

export type InputNumberProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'error' | 'disabled';
  content?: 'value' | 'placeholder' | 'label';
  leadingIcon?: 'true' | 'false';
  trailingIcon?: 'true' | 'false';
  appearance?: 'default' | 'inverse';
  label?: string;
  children?: ReactNode;
};

export function InputNumber({
  state = 'default',
  content = 'value',
  leadingIcon = 'true',
  trailingIcon = 'true',
  appearance = 'default',
  label = 'InputNumber',
  children,
  className,
  ...rest
}: InputNumberProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      data-content={content}
      data-leadingIcon={leadingIcon}
      data-trailingIcon={trailingIcon}
      data-appearance={appearance}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>InputNumber · DS React</p>
    </div>
  );
}
