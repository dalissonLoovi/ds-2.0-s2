import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './VerificationCodeInput.module.css';

export type VerificationCodeInputProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'error' | 'disabled';
  label?: string;
  children?: ReactNode;
};

export function VerificationCodeInput({
  state = 'default',
  label = 'VerificationCodeInput',
  children,
  className,
  ...rest
}: VerificationCodeInputProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>VerificationCodeInput · DS React</p>
    </div>
  );
}
