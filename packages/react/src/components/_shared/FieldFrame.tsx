import type { ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './FieldFrame.module.css';

export type FieldFrameAppearance = 'default' | 'inverse';
export type FieldFrameState = 'default' | 'hover' | 'focus' | 'error' | 'disabled';

export type FieldFrameProps = {
  appearance?: FieldFrameAppearance;
  state?: FieldFrameState;
  label?: string;
  htmlFor?: string;
  supportingText?: string;
  showSupportingText?: boolean;
  supportId?: string;
  className?: string;
  fieldClassName?: string;
  children: ReactNode;
  trailingMeta?: ReactNode;
};

export function FieldFrame({
  appearance = 'default',
  state = 'default',
  label,
  htmlFor,
  supportingText = 'Supporting text',
  showSupportingText = true,
  supportId,
  className,
  fieldClassName,
  children,
  trailingMeta,
}: FieldFrameProps) {
  const isError = state === 'error';

  return (
    <div
      className={cx(
        styles.root,
        styles[`appearance-${appearance}`],
        styles[`state-${state}`],
        className,
      )}
      data-state={state}
      data-appearance={appearance}
    >
      {label != null && (
        <label className={styles.label} htmlFor={htmlFor}>
          {label}
        </label>
      )}
      <div className={cx(styles.field, fieldClassName)}>{children}</div>
      {(showSupportingText || trailingMeta) && (
        <div className={styles.metaRow}>
          {showSupportingText && (
            <p id={supportId} className={cx(styles.support, isError && styles.supportError)}>
              {supportingText}
            </p>
          )}
          {trailingMeta}
        </div>
      )}
    </div>
  );
}
