import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SearchViewFullscreen.module.css';

export type SearchViewFullscreenProps = HTMLAttributes<HTMLDivElement> & {
  content?: 'value' | 'placeholder';
  showResults?: 'true' | 'false';
  label?: string;
  children?: ReactNode;
};

export function SearchViewFullscreen({
  content = 'value',
  showResults = 'true',
  label = 'SearchViewFullscreen',
  children,
  className,
  ...rest
}: SearchViewFullscreenProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-content={content}
      data-showResults={showResults}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SearchViewFullscreen · DS React</p>
    </div>
  );
}
