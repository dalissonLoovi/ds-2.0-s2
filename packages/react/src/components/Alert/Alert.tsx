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
  /**
   * Shows the close action (x-outline 24) at the top-right corner.
   * Colour follows the title (text/primary | text/on-color); accessible name "Fechar alerta".
   * @default false
   */
  showClose?: boolean;
  /** Called when the close action is activated (only rendered when `showClose`). */
  onClose?: () => void;
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
  showClose = false,
  onClose,
  icon,
  className,
  role = 'status',
  ...rest
}: AlertProps) {
  const IconName = statusIcon[status];
  const Icon = IconName ? resolveIcon(IconName) : null;
  const isInverse = appearance === 'inverse';

  return (
    <div
      className={cx(
        styles.root,
        styles[`appearance-${appearance}`],
        styles[`status-${status}`],
        showClose && styles.hasClose,
        className,
      )}
      role={role}
      data-status={status}
      data-appearance={appearance}
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
            intent="primary"
            appearance={isInverse ? 'inverse' : 'default'}
            className={styles.action}
            label={actionLabel}
            onClick={onAction}
          />
        </div>
      )}
      {showClose && (
        <Button
          className={styles.close}
          variant="text"
          size="lg"
          intent="primary"
          appearance={isInverse ? 'inverse' : 'default'}
          showLabel={false}
          showIcon
          icon="x-outline"
          aria-label="Fechar alerta"
          onClick={onClose}
        />
      )}
    </div>
  );
}
