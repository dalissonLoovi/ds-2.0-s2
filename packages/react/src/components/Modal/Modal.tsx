import {
  useEffect,
  useId,
  useRef,
  type HTMLAttributes,
  type ReactNode,
} from 'react';
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

const FOCUSABLE =
  'a[href],button:not([disabled]),textarea:not([disabled]),input:not([disabled]),select:not([disabled]),[tabindex]:not([tabindex="-1"])';

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
  const titleId = useId();
  const dialogRef = useRef<HTMLDivElement>(null);
  const onCloseRef = useRef(onClose);
  onCloseRef.current = onClose;

  useEffect(() => {
    if (!open) return;

    const dialog = dialogRef.current;
    const previouslyFocused = document.activeElement as HTMLElement | null;
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';

    const getFocusable = () =>
      dialog
        ? Array.from(dialog.querySelectorAll<HTMLElement>(FOCUSABLE)).filter(
            (el) => !el.hasAttribute('disabled') && el.getAttribute('aria-hidden') !== 'true',
          )
        : [];

    const initial = getFocusable()[0] ?? dialog;
    initial?.focus();

    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        event.preventDefault();
        onCloseRef.current?.();
        return;
      }
      if (event.key !== 'Tab' || !dialog) return;

      const nodes = getFocusable();
      if (nodes.length === 0) {
        event.preventDefault();
        dialog.focus();
        return;
      }

      const first = nodes[0];
      const last = nodes[nodes.length - 1];
      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault();
        last.focus();
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault();
        first.focus();
      }
    };

    document.addEventListener('keydown', onKeyDown);
    return () => {
      document.removeEventListener('keydown', onKeyDown);
      document.body.style.overflow = previousOverflow;
      previouslyFocused?.focus?.();
    };
  }, [open]);

  if (!open) return null;

  return (
    <div className={styles.overlay} role="presentation">
      <div
        ref={dialogRef}
        className={cx(styles.dialog, styles[`platform-${platform}`], className)}
        role="dialog"
        aria-modal="true"
        aria-labelledby={titleId}
        data-platform={platform}
        tabIndex={-1}
        {...rest}
      >
        <header className={styles.header}>
          <div className={styles.heading}>
            <h2 id={titleId} className={styles.title}>
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
