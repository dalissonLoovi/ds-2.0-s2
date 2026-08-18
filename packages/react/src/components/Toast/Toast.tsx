import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import styles from './Toast.module.css';

export type ToastStatus = 'system' | 'info' | 'success' | 'danger' | 'warning';

export type ToastProps = HTMLAttributes<HTMLDivElement> & {
  status?: ToastStatus;
  message?: string;
  showAction?: boolean;
  actionLabel?: string;
  dismissible?: boolean;
  onAction?: () => void;
  onDismiss?: () => void;
};

const statusIcon = {
  system: null,
  info: 'info-circle-filled',
  success: 'circle-check-filled',
  danger: 'alert-circle-filled',
  warning: 'alert-circle-filled',
} as const;

export function Toast({
  status = 'info',
  message = 'Message',
  showAction = false,
  actionLabel = 'Action',
  dismissible = true,
  onAction,
  onDismiss,
  className,
  role = 'status',
  ...rest
}: ToastProps) {
  const IconName = statusIcon[status];
  const Icon = IconName ? resolveIcon(IconName) : null;

  return (
    <div
      className={cx(styles.root, styles[`status-${status}`], className)}
      role={role}
      data-status={status}
      {...rest}
    >
      {Icon && (
        <span className={styles.icon} aria-hidden>
          <Icon size={20} />
        </span>
      )}
      <p className={styles.message}>{message}</p>
      <div className={styles.actions}>
        {showAction && (
          <Button variant="text" size="sm" intent="primary" label={actionLabel} onClick={onAction} />
        )}
        {dismissible && (
          <Button
            variant="text"
            size="sm"
            intent="primary"
            showLabel={false}
            showIcon
            icon="x-outline"
            aria-label="Dismiss"
            onClick={onDismiss}
          />
        )}
      </div>
    </div>
  );
}
