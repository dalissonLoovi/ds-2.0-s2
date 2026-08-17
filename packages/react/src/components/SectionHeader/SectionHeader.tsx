import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './SectionHeader.module.css';

export type SectionHeaderProps = HTMLAttributes<HTMLDivElement> & {
  emphasis?: 'primary' | 'secondary';
  showAction?: 'false' | 'true';
  label?: string;
  children?: ReactNode;
};

export function SectionHeader({
  emphasis = 'primary',
  showAction = 'false',
  label = 'SectionHeader',
  children,
  className,
  ...rest
}: SectionHeaderProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-emphasis={emphasis}
      data-showAction={showAction}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>SectionHeader · DS React</p>
    </div>
  );
}
