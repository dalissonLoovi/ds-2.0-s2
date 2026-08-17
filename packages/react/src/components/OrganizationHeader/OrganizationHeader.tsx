import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './OrganizationHeader.module.css';

export type OrganizationHeaderProps = HTMLAttributes<HTMLDivElement> & {

  label?: string;
  children?: ReactNode;
};

export function OrganizationHeader({

  label = 'OrganizationHeader',
  children,
  className,
  ...rest
}: OrganizationHeaderProps) {
  return (
    <div
      className={cx(styles.root, className)}

      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>OrganizationHeader · DS React</p>
    </div>
  );
}
