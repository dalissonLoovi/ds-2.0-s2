import type { ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './FieldFrame.module.css';

export type FieldFrameAppearance = 'default' | 'inverse';
export type FieldFrameState = 'default' | 'hover' | 'focus' | 'error' | 'disabled';
export type FieldContent = 'value' | 'placeholder' | 'label';

export type FieldFrameProps = {
  appearance?: FieldFrameAppearance;
  state?: FieldFrameState;
  content?: FieldContent;
  /** Override floated label; defaults from content + state=focus */
  labelFloated?: boolean;
  label?: string;
  htmlFor?: string;
  supportingText?: string;
  showSupportingText?: boolean;
  supportId?: string;
  className?: string;
  fieldClassName?: string;
  fieldLayout?: 'singleline' | 'multiline';
  radiusVariant?: 'input' | 'textarea';
  leading?: ReactNode;
  trailing?: ReactNode;
  children: ReactNode;
  trailingMeta?: ReactNode;
};

export function FieldFrame({
  appearance = 'default',
  state = 'default',
  content = 'placeholder',
  labelFloated,
  label,
  htmlFor,
  supportingText = 'Supporting text',
  showSupportingText = true,
  supportId,
  className,
  fieldClassName,
  fieldLayout = 'singleline',
  radiusVariant = 'input',
  leading,
  trailing,
  children,
  trailingMeta,
}: FieldFrameProps) {
  const isError = state === 'error';
  const floated =
    labelFloated ?? (content === 'value' || content === 'placeholder' || state === 'focus');

  return (
    <div
      className={cx(
        styles.root,
        floated && styles.rootFloated,
        styles[`appearance-${appearance}`],
        styles[`state-${state}`],
        className,
      )}
      data-state={state}
      data-appearance={appearance}
      data-content={content}
    >
      <div
        className={cx(
          styles.field,
          fieldLayout === 'multiline' && styles.fieldMultiline,
          radiusVariant === 'textarea' && styles.radiusTextarea,
          floated ? styles.fieldFloated : styles.fieldResting,
          leading != null && styles.fieldHasLeading,
          fieldClassName,
        )}
      >
        <div className={styles.fieldInner}>
          {leading != null && <span className={styles.leading}>{leading}</span>}
          <div className={styles.controlSlot}>{children}</div>
          {trailing != null && <span className={styles.trailing}>{trailing}</span>}
          {!floated && label != null && htmlFor != null && (
            <label htmlFor={htmlFor} className={styles.restingLabel}>
              {label}
            </label>
          )}
        </div>

        {label != null && (
          <fieldset className={styles.notchedOutline} aria-hidden="true">
            <legend className={cx(styles.notchedLegend, floated && styles.notchedLegendOpen)}>
              {floated ? (
                <span className={styles.notchedLegendMeasure}>{label}</span>
              ) : (
                <span className={styles.notchedLegendMeasure} aria-hidden="true">
                  {'\u00a0'}
                </span>
              )}
            </legend>
          </fieldset>
        )}

        {floated && label != null && htmlFor != null && (
          <label htmlFor={htmlFor} className={styles.floatedLabel}>
            {label}
          </label>
        )}
      </div>

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

export { styles as fieldFrameStyles };
