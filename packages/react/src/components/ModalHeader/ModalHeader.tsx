import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './ModalHeader.module.css';

export type ModalHeaderProps = HTMLAttributes<HTMLDivElement> & {
  layout?: 'desktop' | 'mobile';
  alignment?: 'start' | 'center';
  label?: string;
  children?: ReactNode;
};

export function ModalHeader({
  layout = 'desktop',
  alignment = 'start',
  label = 'ModalHeader',
  children,
  className,
  ...rest
}: ModalHeaderProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-layout={layout}
      data-alignment={alignment}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>ModalHeader · DS React</p>
    </div>
  );
}
