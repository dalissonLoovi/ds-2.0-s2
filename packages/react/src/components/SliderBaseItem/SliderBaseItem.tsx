import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SliderBaseItem.module.css';

export type SliderBaseItemProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function SliderBaseItem({

  label = 'SliderBaseItem',
  children,
  className,
  ...rest
}: SliderBaseItemProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SliderBaseItem · DS React</p>
    </div>
  );
}
