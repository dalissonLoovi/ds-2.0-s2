import type { ButtonHTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './TableExpandCell.module.css';

export type TableExpandCellType = 'body' | 'header';
export type TableExpandCellState =
  | 'default'
  | 'hover'
  | 'pressed'
  | 'selected'
  | 'focus'
  | 'disabled';

export type TableExpandCellProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'type'> & {
  type?: TableExpandCellType;
  state?: TableExpandCellState;
  showChevron?: boolean;
  icon?: DsIconName | IconComponent | ReactNode;
  expanded?: boolean;
};

export function TableExpandCell({
  type = 'body',
  state = 'default',
  showChevron = true,
  icon,
  expanded,
  disabled = false,
  className,
  ...rest
}: TableExpandCellProps) {
  const isExpanded = expanded ?? state === 'selected';
  const isDisabled = disabled || state === 'disabled';
  const isHeader = type === 'header' && !showChevron;
  const resolved = icon ?? (isExpanded ? 'chevron-up-outline' : 'chevron-down-outline');
  const Icon =
    typeof resolved === 'string' || typeof resolved === 'function'
      ? resolveIcon(resolved as DsIconName | IconComponent)
      : null;

  if (isHeader) {
    return <th className={cx(styles.spacer, className)} aria-hidden />;
  }

  return (
    <td className={styles.cell}>
      <button
        type="button"
        className={cx(styles.button, styles[`state-${state}`], isDisabled && styles.disabled, className)}
        aria-expanded={isExpanded}
        aria-label={isExpanded ? 'Collapse' : 'Expand'}
        disabled={isDisabled}
        data-type={type}
        data-state={state}
        {...rest}
      >
        {showChevron && (Icon ? <Icon size={16} aria-hidden /> : (resolved as ReactNode))}
      </button>
    </td>
  );
}
