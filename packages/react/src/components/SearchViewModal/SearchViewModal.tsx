import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SearchViewModal.module.css';

export type SearchViewModalProps = HTMLAttributes<HTMLDivElement> & {
  content?: 'value' | 'placeholder';
  showResults?: 'true' | 'false';
  label?: string;
  children?: ReactNode;
};

export function SearchViewModal({
  content = 'value',
  showResults = 'true',
  label = 'SearchViewModal',
  children,
  className,
  ...rest
}: SearchViewModalProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-content={content}
      data-showResults={showResults}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SearchViewModal · DS React</p>
    </div>
  );
}
