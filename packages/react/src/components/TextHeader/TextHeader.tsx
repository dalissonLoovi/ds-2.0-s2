import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './TextHeader.module.css';

export type TextHeaderProps = HTMLAttributes<HTMLDivElement> & {
  size?: 'large' | 'medium' | 'small';
  alignment?: 'left' | 'center';
  label?: string;
  children?: ReactNode;
};

export function TextHeader({
  size = 'large',
  alignment = 'left',
  label = 'TextHeader',
  children,
  className,
  ...rest
}: TextHeaderProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-size={size}
      data-alignment={alignment}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>TextHeader · DS React</p>
    </div>
  );
}
