import { useId, useState, type HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { SliderBaseItem } from '../SliderBaseItem/SliderBaseItem';
import { SliderSkeletonItem } from '../SliderSkeletonItem/SliderSkeletonItem';
import type { InputState } from '../Input/Input';
import styles from './Slider.module.css';

export type SliderStatus =
  | 'enabled'
  | 'hover'
  | 'focus'
  | 'active'
  | 'error'
  | 'warning'
  | 'disabled'
  | 'read-only'
  | 'skeleton';

export type SliderProps = HTMLAttributes<HTMLDivElement> & {
  status?: SliderStatus;
  errorText?: string;
  warningText?: string;
  label?: string;
  minValue?: string;
  maxValue?: string;
  value?: number;
  defaultValue?: number;
  min?: number;
  max?: number;
  onValueChange?: (value: number) => void;
};

function inputStateFor(status: SliderStatus): InputState {
  if (status === 'hover') return 'hover';
  if (status === 'focus' || status === 'active') return 'focus';
  if (status === 'error') return 'error';
  if (status === 'disabled') return 'disabled';
  return 'default';
}

export function Slider({
  status = 'enabled',
  errorText = 'Enter a valid value',
  warningText = 'Check this value',
  label = 'Label',
  minValue = '0',
  maxValue = '100',
  value: valueProp,
  defaultValue = 40,
  min = 0,
  max = 100,
  onValueChange,
  className,
  ...rest
}: SliderProps) {
  const labelId = useId();
  const feedbackId = useId();
  const [uncontrolled, setUncontrolled] = useState(defaultValue);
  const controlled = valueProp !== undefined;
  const value = controlled ? valueProp : uncontrolled;
  const disabled = status === 'disabled';
  const readOnly = status === 'read-only';
  const showError = status === 'error';
  const showWarning = status === 'warning';
  const active = status === 'active' || status === 'focus' || status === 'hover';

  const setValue = (next: number) => {
    if (disabled || readOnly) return;
    const clamped = Math.max(min, Math.min(max, next));
    if (!controlled) setUncontrolled(clamped);
    onValueChange?.(clamped);
  };

  return (
    <div
      className={cx(styles.root, styles[`status-${status}`], className)}
      data-status={status}
      {...rest}
    >
      {status === 'skeleton' ? (
        <SliderSkeletonItem />
      ) : (
        <>
          <div className={styles.control}>
            <SliderBaseItem
              label={label}
              labelId={labelId}
              minValue={minValue}
              maxValue={maxValue}
              value={value}
              min={min}
              max={max}
              inputState={inputStateFor(status)}
              active={active}
              readOnly={readOnly}
              disabled={disabled}
              onValueChange={setValue}
            />
            <input
              className={styles.range}
              type="range"
              min={min}
              max={max}
              value={value}
              disabled={disabled}
              aria-labelledby={labelId}
              aria-invalid={showError || undefined}
              aria-describedby={showError || showWarning ? feedbackId : undefined}
              onChange={(event) => setValue(Number(event.target.value))}
            />
          </div>
          {showError && (
            <p id={feedbackId} className={styles.error}>
              {errorText}
            </p>
          )}
          {showWarning && (
            <p id={feedbackId} className={styles.warning}>
              {warningText}
            </p>
          )}
        </>
      )}
    </div>
  );
}
