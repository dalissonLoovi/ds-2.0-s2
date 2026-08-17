import {
  forwardRef,
  useId,
  useState,
  type ButtonHTMLAttributes,
} from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import styles from './Switch.module.css';

export type SwitchSize = 'md' | 'sm';
export type SwitchState = 'default' | 'focus' | 'disabled';

export type SwitchProps = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'type'> & {
  size?: SwitchSize;
  state?: SwitchState;
  checked?: boolean;
  defaultChecked?: boolean;
  showIcon?: boolean;
  disabled?: boolean;
  onCheckedChange?: (checked: boolean) => void;
};

export const Switch = forwardRef<HTMLButtonElement, SwitchProps>(function Switch(
  {
    size = 'md',
    state = 'default',
    checked,
    defaultChecked = false,
    showIcon = false,
    disabled = false,
    className,
    onClick,
    onCheckedChange,
    ...rest
  },
  ref,
) {
  const isDisabled = disabled || state === 'disabled';
  const isControlled = checked !== undefined;
  const [uncontrolled, setUncontrolled] = useState(defaultChecked);
  const isOn = isControlled ? Boolean(checked) : uncontrolled;
  const UncheckedIcon = resolveIcon('x-outline');
  const CheckedIcon = resolveIcon('check-outline');

  return (
    <button
      ref={ref}
      type="button"
      role="switch"
      className={cx(
        styles.root,
        styles[`size-${size}`],
        styles[`state-${state}`],
        isDisabled && styles.disabled,
        className,
      )}
      aria-checked={isOn}
      aria-disabled={isDisabled || undefined}
      disabled={isDisabled}
      data-size={size}
      data-state={isDisabled ? 'disabled' : state}
      data-checked={String(isOn)}
      onClick={(event) => {
        if (isDisabled) return;
        const next = !isOn;
        if (!isControlled) setUncontrolled(next);
        onCheckedChange?.(next);
        onClick?.(event);
      }}
      {...rest}
    >
      <span className={styles.track} aria-hidden>
        <span className={styles.thumb}>
          {showIcon &&
            size === 'md' &&
            (isOn
              ? CheckedIcon && <CheckedIcon size={12} />
              : UncheckedIcon && <UncheckedIcon size={12} />)}
        </span>
      </span>
    </button>
  );
});

Switch.displayName = 'Switch';
