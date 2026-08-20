import { useId, useState, type HTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import styles from './Accordion.module.css';

export type AccordionSize = 'sm' | 'md';
export type AccordionPadding = 'padded' | 'flush';
export type AccordionState = 'default' | 'disabled';

export type AccordionProps = HTMLAttributes<HTMLDivElement> & {
  expanded?: boolean;
  defaultExpanded?: boolean;
  state?: AccordionState;
  size?: AccordionSize;
  padding?: AccordionPadding;
  label?: string;
  showSubtitle?: boolean;
  subtitle?: string;
  showAction?: boolean;
  actionLabel?: string;
  onAction?: () => void;
  showSummary?: boolean;
  summary?: string;
  children?: ReactNode;
  onExpandedChange?: (expanded: boolean) => void;
};

export function Accordion({
  expanded: expandedProp,
  defaultExpanded = false,
  state = 'default',
  size = 'md',
  padding = 'padded',
  label = 'Label',
  showSubtitle = false,
  subtitle = 'Subtitle',
  showAction = false,
  actionLabel = 'Action',
  onAction,
  showSummary = false,
  summary = 'Summary',
  children = 'Panel content',
  className,
  onExpandedChange,
  ...rest
}: AccordionProps) {
  const panelId = useId();
  const triggerId = useId();
  const disabled = state === 'disabled';
  const controlled = expandedProp !== undefined;
  const [uncontrolled, setUncontrolled] = useState(defaultExpanded);
  const expanded = disabled ? false : controlled ? Boolean(expandedProp) : uncontrolled;

  const toggle = () => {
    if (disabled) return;
    const next = !expanded;
    if (!controlled) setUncontrolled(next);
    onExpandedChange?.(next);
  };
  const Chevron = resolveIcon(expanded ? 'chevron-up-outline' : 'chevron-down-outline');

  return (
    <div
      className={cx(
        styles.root,
        styles[`size-${size}`],
        styles[`padding-${padding}`],
        disabled && styles.disabled,
        className,
      )}
      data-expanded={expanded}
      data-state={disabled ? 'disabled' : state}
      data-size={size}
      data-padding={padding}
      {...rest}
    >
      <div className={styles.header}>
        <button
          id={triggerId}
          type="button"
          className={styles.trigger}
          aria-expanded={expanded}
          aria-controls={panelId}
          disabled={disabled}
          onClick={toggle}
        >
          <span className={styles.copy}>
            <span className={styles.label}>{label}</span>
            {showSubtitle && <span className={styles.subtitle}>{subtitle}</span>}
          </span>
          {Chevron && <Chevron size={20} aria-hidden className={styles.chevron} />}
        </button>
        {showAction && (
          <Button variant="text" size="sm" intent="primary" label={actionLabel} onClick={onAction} disabled={disabled} />
        )}
      </div>
      {showSummary && !expanded && <p className={styles.summary}>{summary}</p>}
      <div id={panelId} role="region" aria-labelledby={triggerId} hidden={!expanded} className={styles.panel}>
        {children}
      </div>
    </div>
  );
}
