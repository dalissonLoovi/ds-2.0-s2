import { forwardRef, type InputHTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './VerificationCodeInputItem.module.css';

export type VerificationCodeInputItemState =
  | 'default'
  | 'hover'
  | 'focus'
  | 'error'
  | 'disabled';

export type VerificationCodeInputItemProps = Omit<
  InputHTMLAttributes<HTMLInputElement>,
  'size' | 'type'
> & {
  state?: VerificationCodeInputItemState;
  digit?: string;
  disabled?: boolean;
};

export const VerificationCodeInputItem = forwardRef<
  HTMLInputElement,
  VerificationCodeInputItemProps
>(function VerificationCodeInputItem(
  {
    state = 'default',
    digit,
    defaultValue,
    disabled = false,
    className,
    maxLength = 1,
    inputMode = 'numeric',
    ...rest
  },
  ref,
) {
  const isDisabled = disabled || state === 'disabled';
  const isError = state === 'error';
  const controlled = digit !== undefined;

  return (
    <input
      ref={ref}
      type="text"
      className={cx(
        styles.root,
        styles[`state-${state}`],
        isDisabled && styles.disabled,
        className,
      )}
      value={controlled ? digit : undefined}
      defaultValue={controlled ? undefined : (defaultValue ?? '')}
      disabled={isDisabled}
      maxLength={maxLength}
      inputMode={inputMode}
      aria-invalid={isError || undefined}
      data-state={isDisabled ? 'disabled' : state}
      {...rest}
    />
  );
});

VerificationCodeInputItem.displayName = 'VerificationCodeInputItem';
