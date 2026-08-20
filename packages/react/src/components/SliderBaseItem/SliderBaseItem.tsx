import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { Input, type InputState } from '../Input/Input';
import { SliderItem } from '../SliderItem/SliderItem';
import styles from './SliderBaseItem.module.css';

export type SliderBaseItemProps = HTMLAttributes<HTMLDivElement> & {
  label?: string;
  labelId?: string;
  minValue?: string;
  maxValue?: string;
  value?: number;
  min?: number;
  max?: number;
  inputState?: InputState;
  active?: boolean;
  readOnly?: boolean;
  disabled?: boolean;
  onValueChange?: (value: number) => void;
  children?: ReactNode;
};

export function SliderBaseItem({
  label = 'Label',
  labelId,
  minValue = '0',
  maxValue = '100',
  value = 40,
  min = 0,
  max = 100,
  inputState = 'default',
  active = false,
  readOnly = false,
  disabled = false,
  onValueChange,
  className,
  children,
  ...rest
}: SliderBaseItemProps) {
  const clamped = Math.max(min, Math.min(max, value));
  const fillPercent = max === min ? 0 : ((clamped - min) / (max - min)) * 100;

  return (
    <div className={cx(styles.root, className)} {...rest}>
      {children ?? (
        <>
          <p id={labelId} className={styles.label}>{label}</p>
          <div className={styles.sliderRow}>
            <div className={styles.railRow}>
              <span className={styles.bound}>{minValue}</span>
              <SliderItem active={active} fillPercent={fillPercent} />
              <span className={styles.bound}>{maxValue}</span>
            </div>
            <Input
              className={styles.input}
              content="value"
              appearance="default"
              state={inputState}
              label={label}
              showSupportingText={false}
              leadingIcon={false}
              trailingIcon={false}
              value={String(Math.round(clamped))}
              disabled={disabled}
              readOnly={readOnly}
              inputMode="numeric"
              onChange={(event) => {
                const next = Number(event.target.value);
                if (Number.isFinite(next)) onValueChange?.(next);
              }}
            />
          </div>
        </>
      )}
    </div>
  );
}
