import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ListActionDropdown.module.css';

export type ListActionDropdownProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function ListActionDropdown({

  label = 'ListActionDropdown',
  children,
  className,
  ...rest
}: ListActionDropdownProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ListActionDropdown · DS React</p>
    </div>
  );
}
