import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './InputPassword.module.css';

export type InputPasswordProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'error' | 'disabled';
  content?: 'value' | 'placeholder' | 'label';
  leadingIcon?: 'true' | 'false';
  visibility?: 'hidden' | 'visible';
  appearance?: 'default' | 'inverse';
  label?: string;
  children?: ReactNode;
};

export function InputPassword({
  state = 'default',
  content = 'value',
  leadingIcon = 'true',
  visibility = 'hidden',
  appearance = 'default',
  label = 'InputPassword',
  children,
  className,
  ...rest
}: InputPasswordProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      data-content={content}
      data-leadingIcon={leadingIcon}
      data-visibility={visibility}
      data-appearance={appearance}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>InputPassword · DS React</p>
    </div>
  );
}
