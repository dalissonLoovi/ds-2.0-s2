import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Accordion.module.css';

export type AccordionProps = HTMLAttributes<HTMLDivElement> & {
  expanded?: 'false' | 'true';
  state?: 'default' | 'disabled';
  size?: 'sm' | 'md';
  padding?: 'padded' | 'flush';
  label?: string;
  children?: ReactNode;
};

export function Accordion({
  expanded = 'false',
  state = 'default',
  size = 'sm',
  padding = 'padded',
  label = 'Accordion',
  children,
  className,
  ...rest
}: AccordionProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-expanded={expanded}
      data-state={state}
      data-size={size}
      data-padding={padding}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Accordion · DS React</p>
    </div>
  );
}
