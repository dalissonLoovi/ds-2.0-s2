import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ImageItem.module.css';

export type ImageItemProps = HTMLAttributes<HTMLDivElement> & {
  aspectRatio?: '1-1' | '4-3' | '3-2' | '16-9' | '2-1';
  orientation?: 'portrait' | 'landscape';
  verticalResize?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function ImageItem({
  aspectRatio = '1-1',
  orientation = 'portrait',
  verticalResize = 'false',
  label = 'ImageItem',
  children,
  className,
  ...rest
}: ImageItemProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-aspectRatio={aspectRatio}
      data-orientation={orientation}
      data-verticalResize={verticalResize}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ImageItem · DS React</p>
    </div>
  );
}
