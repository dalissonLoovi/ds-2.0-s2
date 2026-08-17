import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import { ChipTag } from '../ChipTag/ChipTag';
import styles from './TableMobileCell.module.css';

export type TableMobileCellType = 'primary' | 'secondary' | 'tag' | 'action' | 'icon';
export type TableMobileCellState = 'default' | 'hover' | 'pressed' | 'selected';

export type TableMobileCellProps = HTMLAttributes<HTMLDivElement> & {
  type?: TableMobileCellType;
  state?: TableMobileCellState;
  label?: string;
  icon?: DsIconName | IconComponent | ReactNode;
  children?: ReactNode;
  onAction?: () => void;
};

export function TableMobileCell({
  type = 'primary',
  state = 'default',
  label = 'Label',
  icon = 'chevron-right-outline',
  children,
  onAction,
  className,
  ...rest
}: TableMobileCellProps) {
  const Icon =
    typeof icon === 'string' || typeof icon === 'function'
      ? resolveIcon(icon as DsIconName | IconComponent)
      : null;

  return (
    <div
      className={cx(styles.root, styles[`type-${type}`], styles[`state-${state}`], className)}
      data-type={type}
      data-state={state}
      {...rest}
    >
      {type === 'tag' && (children ?? <ChipTag size="sm" label={label} intent="info" emphasis="soft" />)}
      {type === 'action' && (
        <Button variant="text" size="sm" intent="primary" label={label} onClick={onAction} />
      )}
      {type === 'icon' && (
        <span className={styles.icon} aria-label={label}>
          {Icon ? <Icon size={20} /> : (icon as ReactNode)}
        </span>
      )}
      {type === 'primary' && <span className={styles.primary}>{children ?? label}</span>}
      {type === 'secondary' && <span className={styles.secondary}>{children ?? label}</span>}
    </div>
  );
}
