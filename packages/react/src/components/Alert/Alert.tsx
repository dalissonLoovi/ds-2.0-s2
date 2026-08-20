import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import styles from './Alert.module.css';

export type AlertAppearance = 'default' | 'inverse';
export type AlertStatus = 'system' | 'info' | 'success' | 'danger' | 'warning';

export type AlertProps = HTMLAttributes<HTMLDivElement> & {
  appearance?: AlertAppearance;
  status?: AlertStatus;
  title?: string;
  description?: string;
  showDescription?: boolean;
  showAction?: boolean;
  actionLabel?: string;
  onAction?: () => void;
  icon?: ReactNode;
};

const statusIcon = {
  system: null,
  info: 'info-circle-filled',
  success: 'circle-check-filled',
  danger: 'alert-circle-filled',
  warning: 'alert-circle-filled',
} as const;

export function Alert({
  appearance = 'default',
  status = 'info',
  title = 'Title',
  description = 'Description',
  showDescription = true,
  showAction = true,
  actionLabel = 'Action',
  onAction,
  icon,
  className,
  role = 'status',
  ...rest
}: AlertProps) {
  const IconName = statusIcon[status];
  const Icon = IconName ? resolveIcon(IconName) : null;

  return (
    <div
      className={cx(
        styles.root,
        styles[`appearance-${appearance}`],
        styles[`status-${status}`],
        className,
      )}
      role={role}
      data-status={status}
      {...rest}
    >
      <div className={styles.body}>
        {(icon || Icon) && (
          <span className={styles.icon} aria-hidden>
            {icon ?? (Icon ? <Icon size={32} /> : null)}
          </span>
        )}
        <div className={styles.copy}>
          <p className={styles.title}>{title}</p>
          {showDescription && <p className={styles.description}>{description}</p>}
        </div>
      </div>
      {showAction && (
        <div className={styles.actions}>
          <Button
            variant="outline"
            size="sm"
            intent={status === 'danger' ? 'danger' : 'primary'}
            label={actionLabel}
            onClick={onAction}
          />
        </div>
      )}
    </div>
  );
}
