import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import { DatePickerSelect } from '../DatePickerSelect/DatePickerSelect';
import { TextHeader } from '../TextHeader/TextHeader';
import styles from './SystemHeader.module.css';

export type SystemHeaderAppearance = 'default' | 'inverse';
export type SystemHeaderVariant = 'default' | 'simple';

export type SystemHeaderProps = HTMLAttributes<HTMLElement> & {
  appearance?: SystemHeaderAppearance;
  variant?: SystemHeaderVariant;
  showPrimaryAction?: boolean;
  showSecondaryAction?: boolean;
  showTertiaryAction?: boolean;
  showNotificationAction?: boolean;
  showProfileMenu?: boolean;
  showDatePicker?: boolean;
  slot?: ReactNode;
  title?: string;
  description?: string;
  showDescription?: boolean;
  userName?: string;
  showUserName?: boolean;
  avatar?: ReactNode;
  onPrimaryAction?: () => void;
  onSecondaryAction?: () => void;
  onTertiaryAction?: () => void;
  onNotification?: () => void;
  onProfile?: () => void;
};

export function SystemHeader({
  appearance = 'default',
  variant = 'default',
  showPrimaryAction = true,
  showSecondaryAction = true,
  showTertiaryAction = false,
  showNotificationAction = true,
  showProfileMenu = true,
  showDatePicker = false,
  slot,
  title = 'Dashboard',
  description = 'Overview',
  showDescription = true,
  userName = 'Maria Silva',
  showUserName = true,
  avatar,
  onPrimaryAction,
  onSecondaryAction,
  onTertiaryAction,
  onNotification,
  onProfile,
  className,
  ...rest
}: SystemHeaderProps) {
  const inverse = appearance === 'inverse';
  const simple = variant === 'simple';

  return (
    <header
      className={cx(styles.root, simple && styles.simple, inverse && styles.inverse, className)}
      data-appearance={appearance}
      data-variant={variant}
      {...rest}
    >
      <div className={styles.heading}>
        <TextHeader
          size="medium"
          title={title}
          description={description}
          showDescription={showDescription}
          inverse={inverse}
        />
        {showDatePicker && <DatePickerSelect format="month-year" />}
        {slot}
      </div>
      {!simple && (
        <div className={styles.trailing}>
          {showTertiaryAction && (
            <Button variant="text" size="sm" intent="primary" label="More" onClick={onTertiaryAction} />
          )}
          {showSecondaryAction && (
            <Button variant="outline" size="sm" intent="primary" label="Secondary" onClick={onSecondaryAction} />
          )}
          {showPrimaryAction && (
            <Button
              variant="solid"
              size="sm"
              intent="primary"
              label="Primary"
              showIcon
              icon="plus-outline"
              onClick={onPrimaryAction}
            />
          )}
          {showNotificationAction && (
            <Button
              variant="text"
              size="sm"
              intent="primary"
              showLabel={false}
              showIcon
              icon="bell-outline"
              aria-label="Notificações"
              onClick={onNotification}
            />
          )}
          {showProfileMenu && (
            <button type="button" className={styles.profile} aria-haspopup="menu" aria-label="Profile menu" onClick={onProfile}>
              {avatar ?? <span className={styles.avatarFallback} aria-hidden />}
              {showUserName && <span className={styles.userName}>{userName}</span>}
            </button>
          )}
        </div>
      )}
    </header>
  );
}
