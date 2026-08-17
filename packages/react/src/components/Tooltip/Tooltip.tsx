import {
  cloneElement,
  isValidElement,
  useId,
  useState,
  type FocusEvent,
  type HTMLAttributes,
  type KeyboardEvent,
  type MouseEvent,
  type ReactElement,
  type ReactNode,
} from 'react';
import { cx } from '../../utils/cx';
import styles from './Tooltip.module.css';

export type TooltipPlacement =
  | 'top-center'
  | 'top-left'
  | 'top-right'
  | 'bottom-center'
  | 'bottom-left'
  | 'bottom-right';

export type TooltipProps = HTMLAttributes<HTMLDivElement> & {
  placement?: TooltipPlacement;
  description?: string;
  open?: boolean;
  defaultOpen?: boolean;
  children?: ReactNode;
};

type TriggerProps = {
  onMouseEnter?: (event: MouseEvent) => void;
  onMouseLeave?: (event: MouseEvent) => void;
  onFocus?: (event: FocusEvent) => void;
  onBlur?: (event: FocusEvent) => void;
  onKeyDown?: (event: KeyboardEvent) => void;
};

export function Tooltip({
  placement = 'top-center',
  description = 'Tooltip',
  open: openProp,
  defaultOpen = false,
  children,
  className,
  ...rest
}: TooltipProps) {
  const tipId = useId();
  const controlled = openProp !== undefined;
  const [uncontrolledOpen, setUncontrolledOpen] = useState(defaultOpen);
  const open = controlled ? Boolean(openProp) : uncontrolledOpen;

  const setOpen = (next: boolean) => {
    if (!controlled) setUncontrolledOpen(next);
  };

  const trigger =
    isValidElement(children)
      ? cloneElement(children as ReactElement<TriggerProps>, {
          'aria-describedby': open ? tipId : undefined,
          onMouseEnter: (event: MouseEvent) => {
            setOpen(true);
            (children as ReactElement<TriggerProps>).props.onMouseEnter?.(event);
          },
          onMouseLeave: (event: MouseEvent) => {
            setOpen(false);
            (children as ReactElement<TriggerProps>).props.onMouseLeave?.(event);
          },
          onFocus: (event: FocusEvent) => {
            setOpen(true);
            (children as ReactElement<TriggerProps>).props.onFocus?.(event);
          },
          onBlur: (event: FocusEvent) => {
            setOpen(false);
            (children as ReactElement<TriggerProps>).props.onBlur?.(event);
          },
          onKeyDown: (event: KeyboardEvent) => {
            if (event.key === 'Escape') setOpen(false);
            (children as ReactElement<TriggerProps>).props.onKeyDown?.(event);
          },
        } as Partial<TriggerProps> & { 'aria-describedby'?: string })
      : children;

  return (
    <div className={cx(styles.wrap, className)} data-placement={placement} {...rest}>
      {trigger}
      {open && (
        <div
          id={tipId}
          role="tooltip"
          className={cx(styles.tooltip, styles[`placement-${placement}`])}
        >
          <p className={styles.description}>{description}</p>
          <span className={styles.arrow} aria-hidden />
        </div>
      )}
    </div>
  );
}
