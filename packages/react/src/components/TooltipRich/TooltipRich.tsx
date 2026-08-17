import {
  cloneElement,
  isValidElement,
  useEffect,
  useId,
  useRef,
  useState,
  type HTMLAttributes,
  type MouseEvent,
  type ReactElement,
  type ReactNode,
} from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import styles from './TooltipRich.module.css';

export type TooltipRichPlacement =
  | 'top-center'
  | 'top-left'
  | 'top-right'
  | 'bottom-center'
  | 'bottom-left'
  | 'bottom-right';

export type TooltipRichProps = HTMLAttributes<HTMLDivElement> & {
  placement?: TooltipRichPlacement;
  title?: string;
  showTitle?: boolean;
  description?: string;
  showDescription?: boolean;
  showActions?: boolean;
  showPrimaryAction?: boolean;
  showSecondaryAction?: boolean;
  primaryActionLabel?: string;
  secondaryActionLabel?: string;
  onPrimaryAction?: () => void;
  onSecondaryAction?: () => void;
  open?: boolean;
  defaultOpen?: boolean;
  onOpenChange?: (open: boolean) => void;
  children?: ReactNode;
};

type TriggerProps = {
  onClick?: (event: MouseEvent) => void;
  onMouseEnter?: (event: MouseEvent) => void;
  onMouseLeave?: (event: MouseEvent) => void;
};

export function TooltipRich({
  placement = 'top-center',
  title = 'Title',
  showTitle = true,
  description = 'Description',
  showDescription = true,
  showActions = true,
  showPrimaryAction = true,
  showSecondaryAction = true,
  primaryActionLabel = 'Primary',
  secondaryActionLabel = 'Secondary',
  onPrimaryAction,
  onSecondaryAction,
  open: openProp,
  defaultOpen = false,
  onOpenChange,
  children,
  className,
  ...rest
}: TooltipRichProps) {
  const tipId = useId();
  const panelRef = useRef<HTMLDivElement>(null);
  const controlled = openProp !== undefined;
  const [uncontrolledOpen, setUncontrolledOpen] = useState(defaultOpen);
  const open = controlled ? Boolean(openProp) : uncontrolledOpen;
  const actionable = showActions && (showPrimaryAction || showSecondaryAction);

  const setOpen = (next: boolean) => {
    if (!controlled) setUncontrolledOpen(next);
    onOpenChange?.(next);
  };

  useEffect(() => {
    if (!open || !actionable) return;
    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') setOpen(false);
    };
    document.addEventListener('keydown', onKeyDown);
    return () => document.removeEventListener('keydown', onKeyDown);
  }, [open, actionable]);

  const trigger =
    isValidElement(children)
      ? cloneElement(children as ReactElement<TriggerProps>, {
          'aria-describedby': open && !actionable ? tipId : undefined,
          'aria-expanded': actionable ? open : undefined,
          'aria-haspopup': actionable ? 'dialog' : undefined,
          onClick: (event: MouseEvent) => {
            if (actionable) setOpen(!open);
            else setOpen(true);
            (children as ReactElement<TriggerProps>).props.onClick?.(event);
          },
          onMouseEnter: (event: MouseEvent) => {
            if (!actionable) setOpen(true);
            (children as ReactElement<TriggerProps>).props.onMouseEnter?.(event);
          },
          onMouseLeave: (event: MouseEvent) => {
            if (!actionable) setOpen(false);
            (children as ReactElement<TriggerProps>).props.onMouseLeave?.(event);
          },
        } as Partial<TriggerProps> & Record<string, unknown>)
      : children;

  return (
    <div className={cx(styles.wrap, className)} data-placement={placement} {...rest}>
      {trigger}
      {open && (
        <div
          ref={panelRef}
          id={tipId}
          role={actionable ? 'dialog' : 'tooltip'}
          className={cx(styles.panel, styles[`placement-${placement}`])}
        >
          <div className={styles.content}>
            {showTitle && <p className={styles.title}>{title}</p>}
            {showDescription && <p className={styles.description}>{description}</p>}
          </div>
          <span className={styles.arrow} aria-hidden />
          {showActions && (showPrimaryAction || showSecondaryAction) && (
            <div className={styles.actions}>
              {showSecondaryAction && (
                <Button
                  variant="text"
                  size="sm"
                  intent="primary"
                  label={secondaryActionLabel}
                  className={styles.secondary}
                  onClick={() => {
                    onSecondaryAction?.();
                    setOpen(false);
                  }}
                />
              )}
              {showPrimaryAction && (
                <Button
                  variant="solid"
                  size="sm"
                  intent="primary"
                  label={primaryActionLabel}
                  onClick={() => {
                    onPrimaryAction?.();
                    setOpen(false);
                  }}
                />
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
