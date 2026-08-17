import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import styles from './Modal.module.css';

export type ModalPlatform = 'web' | 'mobile' | 'mobile-landscape';

export type ModalProps = HTMLAttributes<HTMLDivElement> & {
  platform?: ModalPlatform;
  open?: boolean;
  title?: string;
  label?: string;
  showLabel?: boolean;
  showCloseAction?: boolean;
  onClose?: () => void;
  children?: ReactNode;
  footer?: ReactNode;
};

export function Modal({
  platform = 'web',
  open = true,
  title = 'Title',
  label = 'Label',
  showLabel = false,
  showCloseAction = true,
  onClose,
  children,
  footer,
  className,
  ...rest
}: ModalProps) {
  if (!open) return null;

  return (
    <div className={styles.overlay} role="presentation">
      <div
        className={cx(styles.dialog, styles[`platform-${platform}`], className)}
        role="dialog"
        aria-modal="true"
        aria-labelledby="ds-modal-title"
        data-platform={platform}
        {...rest}
      >
        <header className={styles.header}>
          <div className={styles.heading}>
            <h2 id="ds-modal-title" className={styles.title}>
              {title}
            </h2>
            {showLabel && <p className={styles.label}>{label}</p>}
          </div>
          {showCloseAction && (
            <Button
              variant="text"
              size="sm"
              intent="primary"
              showLabel={false}
              showIcon
              icon="x-outline"
              aria-label="Close"
              onClick={onClose}
            />
          )}
        </header>
        <div className={styles.body}>{children}</div>
        {footer && <footer className={styles.footer}>{footer}</footer>}
      </div>
    </div>
  );
}
