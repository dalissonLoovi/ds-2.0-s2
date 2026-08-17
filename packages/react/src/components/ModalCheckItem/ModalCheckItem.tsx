import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ModalCheckItem.module.css';

export type ModalCheckItemProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function ModalCheckItem({

  label = 'ModalCheckItem',
  children,
  className,
  ...rest
}: ModalCheckItemProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ModalCheckItem · DS React</p>
    </div>
  );
}
