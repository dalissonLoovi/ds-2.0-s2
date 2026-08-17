import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './InputTextArea.module.css';

export type InputTextAreaProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'error' | 'disabled';
  content?: 'value' | 'placeholder' | 'label';
  leadingIcon?: 'false' | 'true';
  trailingIcon?: 'false' | 'true';
  appearance?: 'default' | 'inverse';
  label?: string;
  children?: ReactNode;
};

export function InputTextArea({
  state = 'default',
  content = 'value',
  leadingIcon = 'false',
  trailingIcon = 'false',
  appearance = 'default',
  label = 'InputTextArea',
  children,
  className,
  ...rest
}: InputTextAreaProps) {
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
      <p className={styles.meta}>InputTextArea · DS React</p>
    </div>
  );
}
