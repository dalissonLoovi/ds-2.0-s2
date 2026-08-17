import { forwardRef, type ButtonHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName, type IconComponent } from '../../icons/dsIcons';
import styles from './ChipClickable.module.css';

export type ChipClickableSize = 'sm' | 'md';
export type ChipClickableState = 'default' | 'hover' | 'pressed' | 'selected' | 'disabled';
export type ChipClickableIntent =
  | 'info'
  | 'system'
  | 'success'
  | 'warning'
  | 'danger'
  | 'outline'
  | 'soft';
export type ChipClickableWidth = 'hug' | 'fill';

export type ChipClickableProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'disabled'> & {
  size?: ChipClickableSize;
  state?: ChipClickableState;
  intent?: ChipClickableIntent;
  width?: ChipClickableWidth;
  label?: string;
  showLeadingIcon?: boolean;
  leadingIcon?: DsIconName | IconComponent | ReactNode;
  showDeleteAction?: boolean;
  showAvatar?: boolean;
  disabled?: boolean;
  selected?: boolean;
  onDelete?: () => void;
};

export const ChipClickable = forwardRef<HTMLButtonElement, ChipClickableProps>(
  function ChipClickable(
    {
      size = 'md',
      state = 'default',
      intent = 'outline',
      width = 'hug',
      label = 'Label',
      showLeadingIcon = false,
      leadingIcon = 'plus-outline',
      showDeleteAction = false,
      showAvatar = false,
      disabled = false,
      selected = false,
      onDelete,
      className,
      type = 'button',
      ...rest
    },
    ref,
  ) {
    const isDisabled = disabled || state === 'disabled';
    const isSelected = selected || state === 'selected';
    const Icon =
      typeof leadingIcon === 'string' || typeof leadingIcon === 'function'
        ? resolveIcon(leadingIcon as DsIconName | IconComponent)
        : null;
    const DeleteIcon = resolveIcon('x-outline');
    const leadingNode =
      showLeadingIcon &&
      (Icon ? (
        <Icon size={size === 'sm' ? 14 : 16} aria-hidden className={styles.icon} />
      ) : (
        (leadingIcon as ReactNode)
      ));

    return (
      <button
        ref={ref}
        type={type}
        className={cx(
          styles.root,
          styles[`size-${size}`],
          styles[`intent-${intent}`],
          styles[`width-${width}`],
          isSelected && styles.selected,
          className,
        )}
        disabled={isDisabled}
        aria-pressed={isSelected || undefined}
        data-intent={intent}
        data-state={state}
        {...rest}
      >
        {showAvatar && <span className={styles.avatar} aria-hidden />}
        {leadingNode}
        <span className={styles.label}>{label}</span>
        {showDeleteAction && DeleteIcon && (
          <span
            className={styles.delete}
            role="presentation"
            onClick={(e) => {
              e.stopPropagation();
              onDelete?.();
            }}
          >
            <DeleteIcon size={14} aria-hidden />
          </span>
        )}
      </button>
    );
  },
);

ChipClickable.displayName = 'ChipClickable';
