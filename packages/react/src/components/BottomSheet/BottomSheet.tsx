import {
  useEffect,
  useId,
  useRef,
  type HTMLAttributes,
  type ReactNode,
} from 'react';
import { cx } from '../../utils/cx';
import { BottomSheetHeader } from '../BottomSheetHeader/BottomSheetHeader';
import styles from './BottomSheet.module.css';

export type BottomSheetHeaderVariant = 'none' | 'sheet-header';

export type BottomSheetProps = HTMLAttributes<HTMLDivElement> & {
  header?: BottomSheetHeaderVariant;
  open?: boolean;
  modal?: boolean;
  title?: string;
  showLabel?: boolean;
  showOptionsAction?: boolean;
  showLeadingAction?: boolean;
  showCloseAction?: boolean;
  onClose?: () => void;
  onOptions?: () => void;
  onLeadingAction?: () => void;
  children?: ReactNode;
};

const FOCUSABLE =
  'a[href],button:not([disabled]),textarea:not([disabled]),input:not([disabled]),select:not([disabled]),[tabindex]:not([tabindex="-1"])';

export function BottomSheet({
  header = 'sheet-header',
  open = true,
  modal = true,
  title = 'Title',
  showLabel = true,
  showOptionsAction = false,
  showLeadingAction = false,
  showCloseAction = true,
  onClose,
  onOptions,
  onLeadingAction,
  children,
  className,
  ...rest
}: BottomSheetProps) {
  const titleId = useId();
  const sheetRef = useRef<HTMLDivElement>(null);
  const onCloseRef = useRef(onClose);
  onCloseRef.current = onClose;

  useEffect(() => {
    if (!open || !modal) return;

    const sheet = sheetRef.current;
    const previouslyFocused = document.activeElement as HTMLElement | null;
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';

    const getFocusable = () =>
      sheet
        ? Array.from(sheet.querySelectorAll<HTMLElement>(FOCUSABLE)).filter(
            (el) => !el.hasAttribute('disabled'),
          )
        : [];

    (getFocusable()[0] ?? sheet)?.focus();

    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        event.preventDefault();
        onCloseRef.current?.();
        return;
      }
      if (event.key !== 'Tab' || !sheet) return;
      const nodes = getFocusable();
      if (nodes.length === 0) {
        event.preventDefault();
        sheet.focus();
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
  }, [open, modal]);

  if (!open) return null;

  return (
    <div
      className={cx(styles.scrim, !modal && styles.scrimPassive)}
      role="presentation"
      onClick={(event) => {
        if (modal && event.target === event.currentTarget) onClose?.();
      }}
    >
      <div
        ref={sheetRef}
        className={cx(styles.sheet, styles[`header-${header}`], className)}
        role={modal ? 'dialog' : 'region'}
        aria-modal={modal || undefined}
        aria-labelledby={header === 'sheet-header' && showLabel ? titleId : undefined}
        tabIndex={-1}
        data-header={header}
        {...rest}
      >
        {header === 'none' && <div className={styles.dragHandle} aria-hidden />}
        {header === 'sheet-header' && (
          <BottomSheetHeader
            title={title}
            showLabel={showLabel}
            showOptionsAction={showOptionsAction}
            showLeadingAction={showLeadingAction}
            showCloseAction={showCloseAction}
            onClose={onClose}
            onOptions={onOptions}
            onLeadingAction={onLeadingAction}
            titleId={titleId}
          />
        )}
        <div className={styles.content}>{children}</div>
      </div>
    </div>
  );
}
