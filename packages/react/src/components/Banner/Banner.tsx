import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import styles from './Banner.module.css';

export type BannerStatus = 'success' | 'warning' | 'info' | 'danger';

export type BannerProps = HTMLAttributes<HTMLDivElement> & {
  status?: BannerStatus;
  message?: string;
  showIcon?: boolean;
  showAction?: boolean;
  actionLabel?: string;
  onAction?: () => void;
  icon?: ReactNode;
};

const STATUS_ICON: Record<BannerStatus, DsIconName> = {
  success: 'check-outline',
  warning: 'alert-triangle-outline',
  info: 'info-circle-outline',
  danger: 'alert-circle-outline',
};

export function Banner({
  status = 'info',
  message = 'Message',
  showIcon = true,
  showAction = false,
  actionLabel = 'Action',
  onAction,
  icon,
  className,
  ...rest
}: BannerProps) {
  const Icon = resolveIcon(STATUS_ICON[status]);
  const role = status === 'warning' || status === 'danger' ? 'alert' : 'status';

  return (
    <div
      className={cx(styles.root, styles[`status-${status}`], className)}
      role={role}
      data-status={status}
      {...rest}
    >
      <div className={styles.body}>
        {showIcon && (
          <span className={styles.icon} aria-hidden>
            {icon ?? (Icon ? <Icon size={20} /> : null)}
          </span>
        )}
        <p className={styles.message}>{message}</p>
      </div>
      {showAction && (
        <div className={styles.actions}>
          <Button
            variant="text"
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
