import { useId, useState, type ButtonHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import { PaginationSelectMenu } from '../PaginationSelectMenu/PaginationSelectMenu';
import styles from './PaginationSelectInput.module.css';

export type PaginationSelectInputSize = 'sm' | 'md' | 'lg';
export type PaginationSelectInputState = 'default' | 'hover';

export type PaginationSelectInputProps = Omit<
  ButtonHTMLAttributes<HTMLButtonElement>,
  'type' | 'value'
> & {
  size?: PaginationSelectInputSize;
  state?: PaginationSelectInputState;
  expanded?: boolean;
  value?: string;
  menu?: ReactNode;
  onExpandedChange?: (expanded: boolean) => void;
};

export function PaginationSelectInput({
  size = 'sm',
  state = 'default',
  expanded: expandedProp,
  value = '10',
  menu,
  onExpandedChange,
  className,
  ...rest
}: PaginationSelectInputProps) {
  const menuId = useId();
  const [uncontrolled, setUncontrolled] = useState(false);
  const controlled = expandedProp !== undefined;
  const expanded = controlled ? expandedProp : uncontrolled;
  const Chevron = resolveIcon(expanded ? 'chevron-up-outline' : 'chevron-down-outline');

  const toggle = () => {
    const next = !expanded;
    if (!controlled) setUncontrolled(next);
    onExpandedChange?.(next);
  };

  return (
    <div className={cx(styles.root, className)}>
      <button
        type="button"
        className={cx(
          styles.trigger,
          styles[`size-${size}`],
          styles[`state-${state}`],
          expanded && styles.expanded,
        )}
        aria-haspopup="listbox"
        aria-expanded={expanded}
        aria-controls={expanded ? menuId : undefined}
        data-size={size}
        data-state={state}
        data-expanded={expanded}
        {...rest}
        onClick={toggle}
      >
        <span className={styles.value}>{value}</span>
        {Chevron && <Chevron size={16} aria-hidden className={styles.chevron} />}
      </button>
      {expanded && (
        <div id={menuId} className={styles.menu}>
          {menu ?? <PaginationSelectMenu />}
        </div>
      )}
    </div>
  );
}
