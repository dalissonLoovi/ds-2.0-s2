import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName } from '../../icons/dsIcons';
import { ListItem, type ListItemCondition, type ListItemLeading, type ListItemTrailing } from '../ListItem/ListItem';
import type { ListItemStateLayerState } from '../ListItemStateLayer/ListItemStateLayer';
import styles from './VerticalStepperItem.module.css';

export type VerticalStepperItemStatus = 'completed' | 'current' | 'pending' | 'error';

export type VerticalStepperItemProps = HTMLAttributes<HTMLLIElement> & {
  status?: VerticalStepperItemStatus;
  showConnector?: boolean;
  headline?: string;
  supportingText?: string;
  overline?: string;
  trailingSupportingText?: string;
  condition?: ListItemCondition;
  showSupportingText?: boolean;
  showOverline?: boolean;
  showTrailingSupportingText?: boolean;
  showDivider?: boolean;
  leading?: ListItemLeading;
  trailing?: ListItemTrailing;
  stateLayer?: ListItemStateLayerState;
};

const STATUS_ICON: Record<VerticalStepperItemStatus, DsIconName> = {
  completed: 'circle-check-filled',
  current: 'circle-dot-filled',
  pending: 'circle-outline',
  error: 'circle-x-filled',
};

export function VerticalStepperItem({
  status = 'completed',
  showConnector = true,
  headline = 'Headline',
  supportingText = 'Supporting text',
  overline = 'Overline',
  trailingSupportingText = 'Meta',
  condition = '2-line',
  showSupportingText = true,
  showOverline = false,
  showTrailingSupportingText = false,
  showDivider = false,
  leading = 'none',
  trailing = 'none',
  stateLayer = 'default',
  className,
  ...rest
}: VerticalStepperItemProps) {
  const Icon = resolveIcon(STATUS_ICON[status]);

  return (
    <li
      className={cx(styles.root, styles[`status-${status}`], className)}
      data-status={status}
      aria-current={status === 'current' ? 'step' : undefined}
      {...rest}
    >
      <div className={styles.indicator} aria-hidden>
        <span className={styles.icon}>{Icon ? <Icon size={20} /> : null}</span>
        {showConnector && <span className={styles.connector} />}
      </div>
      <ListItem
        as="div"
        className={styles.item}
        condition={condition}
        leading={leading}
        trailing={trailing}
        headline={headline}
        supportingText={supportingText}
        overline={overline}
        trailingSupportingText={trailingSupportingText}
        showSupportingText={showSupportingText}
        showOverline={showOverline}
        showTrailingSupportingText={showTrailingSupportingText}
        showDivider={showDivider}
        stateLayer={stateLayer}
      />
    </li>
  );
}
