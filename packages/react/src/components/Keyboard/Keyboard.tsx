import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './Keyboard.module.css';

export type KeyboardProps = HTMLAttributes<HTMLDivElement> & {
  configuration?: 'base-keyboard' | 'alphanumeric' | 'keypad' | 'numeric-only';
  layout?: 'portrait' | 'landscape' | 'floating';
  label?: string;
  children?: ReactNode;
};

export function Keyboard({
  configuration = 'base-keyboard',
  layout = 'portrait',
  label = 'Keyboard',
  children,
  className,
  ...rest
}: KeyboardProps) {
  return (
    <div
      className={cx(styles.root, className)}
      data-configuration={configuration}
      data-layout={layout}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>Keyboard · DS React</p>
    </div>
  );
}
