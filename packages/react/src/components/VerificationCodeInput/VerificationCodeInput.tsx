import {
  useId,
  useRef,
  type ChangeEvent,
  type ClipboardEvent,
  type KeyboardEvent,
  type HTMLAttributes,
} from 'react';
import { cx } from '../../utils/cx';
import { VerificationCodeInputItem } from '../VerificationCodeInputItem/VerificationCodeInputItem';
import styles from './VerificationCodeInput.module.css';

export type VerificationCodeInputState =
  | 'default'
  | 'hover'
  | 'focus'
  | 'error'
  | 'disabled';

export type VerificationCodeInputProps = HTMLAttributes<HTMLDivElement> & {
  state?: VerificationCodeInputState;
  label?: string;
  showLabel?: boolean;
  supportingText?: string;
  showSupportingText?: boolean;
  digit1?: string;
  digit2?: string;
  digit3?: string;
  digit4?: string;
  digit5?: string;
  disabled?: boolean;
  onDigitsChange?: (digits: string[]) => void;
};

const LENGTH = 5;

export function VerificationCodeInput({
  state = 'default',
  label = 'Label',
  showLabel = true,
  supportingText = 'Supporting text',
  showSupportingText = false,
  digit1 = '',
  digit2 = '',
  digit3 = '',
  digit4 = '',
  digit5 = '',
  disabled = false,
  className,
  onDigitsChange,
  ...rest
}: VerificationCodeInputProps) {
  const autoId = useId();
  const supportId = `${autoId}-support`;
  const isDisabled = disabled || state === 'disabled';
  const isError = state === 'error';
  const showSupport = showSupportingText || isError;
  const digits = [digit1, digit2, digit3, digit4, digit5];
  const refs = useRef<Array<HTMLInputElement | null>>([]);

  const updateDigit = (index: number, next: string) => {
    const char = next.replace(/\D/g, '').slice(-1);
    const copy = [...digits];
    copy[index] = char;
    onDigitsChange?.(copy);
    if (char && index < LENGTH - 1) {
      refs.current[index + 1]?.focus();
    }
  };

  const onKeyDown = (index: number, event: KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Backspace' && !digits[index] && index > 0) {
      refs.current[index - 1]?.focus();
    }
  };

  const onPaste = (event: ClipboardEvent<HTMLInputElement>) => {
    const text = event.clipboardData.getData('text').replace(/\D/g, '').slice(0, LENGTH);
    if (!text) return;
    event.preventDefault();
    const copy = Array.from({ length: LENGTH }, (_, i) => text[i] ?? '');
    onDigitsChange?.(copy);
    refs.current[Math.min(text.length, LENGTH - 1)]?.focus();
  };

  return (
    <div
      className={cx(styles.root, styles[`state-${state}`], className)}
      role="group"
      aria-labelledby={showLabel ? `${autoId}-label` : undefined}
      aria-describedby={showSupport ? supportId : undefined}
      aria-disabled={isDisabled || undefined}
      data-state={isDisabled ? 'disabled' : state}
      {...rest}
    >
      {showLabel && (
        <div id={`${autoId}-label`} className={styles.label}>
          {label}
        </div>
      )}
      <div className={styles.row}>
        {digits.map((digit, index) => (
          <VerificationCodeInputItem
            key={index}
            ref={(node) => {
              refs.current[index] = node;
            }}
            state={isDisabled ? 'disabled' : state}
            digit={digit}
            disabled={isDisabled}
            aria-label={`Digit ${index + 1}`}
            onChange={(event: ChangeEvent<HTMLInputElement>) =>
              updateDigit(index, event.target.value)
            }
            onKeyDown={(event) => onKeyDown(index, event)}
            onPaste={onPaste}
          />
        ))}
      </div>
      {showSupport && (
        <p id={supportId} className={cx(styles.support, isError && styles.supportError)}>
          {supportingText}
        </p>
      )}
    </div>
  );
}
