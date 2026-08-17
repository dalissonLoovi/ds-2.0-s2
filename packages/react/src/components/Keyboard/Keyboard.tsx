import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import styles from './Keyboard.module.css';

export type KeyboardConfiguration = 'base-keyboard' | 'alphanumeric' | 'keypad' | 'numeric-only';
export type KeyboardLayout = 'portrait' | 'landscape' | 'floating';

export type KeyboardProps = HTMLAttributes<HTMLDivElement> & {
  configuration?: KeyboardConfiguration;
  layout?: KeyboardLayout;
};

const BASE_ROWS = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'];
const ALPHANUMERIC_ROWS = ['1234567890', 'qwertyuiop', 'asdfghjkl', 'zxcvbnm'];
const KEYPAD = ['123', '456', '789', '*0#'];
const NUMERIC = ['123', '456', '789', ' 0 '];

function rowsFor(configuration: KeyboardConfiguration) {
  if (configuration === 'alphanumeric') return ALPHANUMERIC_ROWS;
  if (configuration === 'keypad') return KEYPAD;
  if (configuration === 'numeric-only') return NUMERIC;
  return BASE_ROWS;
}

export function Keyboard({
  configuration = 'base-keyboard',
  layout = 'portrait',
  className,
  ...rest
}: KeyboardProps) {
  const Photo = resolveIcon('photo-outline');
  const rows = rowsFor(configuration);
  const letterLayout = configuration === 'base-keyboard' || configuration === 'alphanumeric';

  return (
    <div
      className={cx(styles.root, styles[`layout-${layout}`], className)}
      data-configuration={configuration}
      data-layout={layout}
      role="presentation"
      aria-hidden
      {...rest}
    >
      {letterLayout && (
        <div className={styles.toolbar}>
          <span className={styles.tool}>{Photo ? <Photo size={16} /> : 'GIF'}</span>
          <span className={styles.tool}>ABC</span>
          <span className={styles.tool}>123</span>
        </div>
      )}
      <div className={styles.keys}>
        {rows.map((row) => (
          <div key={row} className={styles.row}>
            {row.split('').map((key, index) => (
              <span
                key={`${key}-${index}`}
                className={cx(styles.key, key === ' ' && styles.spacer, /\d|#|\*/.test(key) && styles.wide)}
              >
                {key.trim() ? key : ''}
              </span>
            ))}
          </div>
        ))}
        {letterLayout && (
          <div className={styles.row}>
            <span className={cx(styles.key, styles.mod)}>shift</span>
            <span className={cx(styles.key, styles.space)}>space</span>
            <span className={cx(styles.key, styles.mod)}>enter</span>
          </div>
        )}
      </div>
      <div className={styles.homeIndicator} />
    </div>
  );
}
