import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './FileUploaderList.module.css';

export type FileUploaderListProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function FileUploaderList({

  label = 'FileUploaderList',
  children,
  className,
  ...rest
}: FileUploaderListProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>FileUploaderList · DS React</p>
    </div>
  );
}
