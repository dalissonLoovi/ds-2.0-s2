import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon, type DsIconName } from '../../icons/dsIcons';
import styles from './StepperPrimary.module.css';

export type StepperPrimaryStatus = 'completed' | 'current' | 'pending';
export type StepperPrimaryTrail = 'both' | 'left' | 'right';
export type StepperPrimaryTrailState = 'none' | 'both' | 'left' | 'right';

export type StepperPrimaryProps = HTMLAttributes<HTMLDivElement> & {
  status?: StepperPrimaryStatus;
  trail?: StepperPrimaryTrail;
  trailState?: StepperPrimaryTrailState;
  label?: string;
};

const STATUS_ICON: Record<StepperPrimaryStatus, DsIconName> = {
  completed: 'circle-check-filled',
  current: 'circle-dot-filled',
  pending: 'circle-outline',
};

function trailActive(side: 'left' | 'right', trail: StepperPrimaryTrail, trailState: StepperPrimaryTrailState) {
  const present = trail === 'both' || trail === side;
  if (!present) return null;
  const active = trailState === 'both' || trailState === side;
  return active ? 'active' : 'inactive';
}

export function StepperPrimary({
  status = 'completed',
  trail = 'both',
  trailState = 'none',
  label = 'Step',
  className,
  ...rest
}: StepperPrimaryProps) {
  const Icon = resolveIcon(STATUS_ICON[status]);
  const left = trailActive('left', trail, trailState);
  const right = trailActive('right', trail, trailState);

  return (
    <div
      className={cx(styles.root, styles[`status-${status}`], className)}
      data-status={status}
      data-trail={trail}
      data-trail-state={trailState}
      {...rest}
    >
      {left && <span className={cx(styles.trail, styles.left, styles[left])} aria-hidden />}
      <span className={styles.icon} aria-hidden>
        {Icon ? <Icon size={20} /> : null}
      </span>
      {right && <span className={cx(styles.trail, styles.right, styles[right])} aria-hidden />}
      <span className={styles.label}>{label}</span>
    </div>
  );
}
