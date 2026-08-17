import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './VerificationCodeInputItem.module.css';

export type VerificationCodeInputItemProps = HTMLAttributes<HTMLDivElement> & {
  state?: 'default' | 'hover' | 'focus' | 'error' | 'disabled';
  label?: string;
  children?: ReactNode;
};

export function VerificationCodeInputItem({
  state = 'default',
  label = 'VerificationCodeInputItem',
  children,
  className,
  ...rest
}: VerificationCodeInputItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-state={state}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>VerificationCodeInputItem · DS React</p>
    </div>
  );
}
