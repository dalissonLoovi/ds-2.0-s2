import {
  useEffect,
  useId,
  useRef,
  type HTMLAttributes,
  type ReactNode,
} from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import { ModalHeader } from '../ModalHeader/ModalHeader';
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
  /**
   * Custom footer content (escape hatch). When provided it is always rendered and takes
   * precedence over the built-in actions. Rendered as a horizontal, right-aligned row on every
   * platform (same as before `showFooter` existed); the consumer owns order and layout — keep
   * DOM order = visual order so keyboard focus follows what is seen.
   */
  footer?: ReactNode;
  /**
   * Figma `showFooter`: renders the built-in footer with up to 2 actions — primary
   * (Button solid) + secondary (Button text). web: horizontal, right-aligned, size=lg;
   * mobile|mobile-landscape: vertical, full width, primary on top, size=md. Gap spacing/100.
   * Ignored when `footer` is provided.
   * @default false
   */
  showFooter?: boolean;
  /** @default 'Confirmar' */
  primaryActionLabel?: string;
  onPrimaryAction?: () => void;
  /** @default true */
  showSecondaryAction?: boolean;
  /** @default 'Cancelar' */
  secondaryActionLabel?: string;
  onSecondaryAction?: () => void;
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
  showFooter = false,
  primaryActionLabel = 'Confirmar',
  onPrimaryAction,
  showSecondaryAction = true,
  secondaryActionLabel = 'Cancelar',
  onSecondaryAction,
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

  const isWeb = platform === 'web';
  const actionSize = isWeb ? 'lg' : 'md';
  const useBuiltInFooter = footer == null && showFooter;
  const secondaryAction = showSecondaryAction ? (
    <Button
      variant="text"
      intent="primary"
      size={actionSize}
      label={secondaryActionLabel}
      onClick={onSecondaryAction}
    />
  ) : null;
  const primaryAction = (
    <Button
      variant="solid"
      intent="primary"
      size={actionSize}
      label={primaryActionLabel}
      onClick={onPrimaryAction}
    />
  );
  // DOM order = visual order, so keyboard focus follows what is seen:
  // web → secondary, primary (row, right-aligned); mobile → primary on top, secondary below.
  const footerContent =
    footer ??
    (useBuiltInFooter ? (
      isWeb ? (
        <>
          {secondaryAction}
          {primaryAction}
        </>
      ) : (
        <>
          {primaryAction}
          {secondaryAction}
        </>
      )
    ) : null);

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
        <ModalHeader
          layout={platform === 'web' ? 'desktop' : 'mobile'}
          title={title}
          label={label}
          showLabel={showLabel}
          showCloseAction={showCloseAction}
          onClose={onClose}
          titleId={titleId}
        />
        <div className={styles.body}>{children}</div>
        {footerContent && (
          <footer className={cx(styles.footer, useBuiltInFooter && !isWeb && styles.footerStacked)}>
            {footerContent}
          </footer>
        )}
      </div>
    </div>
  );
}
