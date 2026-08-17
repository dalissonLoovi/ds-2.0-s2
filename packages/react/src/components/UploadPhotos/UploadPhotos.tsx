import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import { ChipTag } from '../ChipTag/ChipTag';
import styles from './UploadPhotos.module.css';

export type UploadPhotosStatus = 'pending' | 'in-review' | 'approved' | 'rejected';

export type UploadPhotosProps = HTMLAttributes<HTMLDivElement> & {
  status?: UploadPhotosStatus;
  label?: string;
  description?: string;
  showDescription?: boolean;
  onAction?: () => void;
};

const STATUS_CHIP: Record<UploadPhotosStatus, { label: string; intent: 'info' | 'system' | 'success' | 'danger' }> = {
  pending: { label: 'Pendente', intent: 'system' },
  'in-review': { label: 'Em análise', intent: 'info' },
  approved: { label: 'Aprovado', intent: 'success' },
  rejected: { label: 'Reprovado', intent: 'danger' },
};

export function UploadPhotos({
  status = 'pending',
  label = 'Foto do documento',
  description = 'Envie uma foto nítida do documento.',
  showDescription = false,
  onAction,
  className,
  ...rest
}: UploadPhotosProps) {
  const Camera = resolveIcon('camera-outline');
  const chip = STATUS_CHIP[status];
  const actionable = status === 'pending' || status === 'rejected';

  return (
    <div
      className={cx(styles.root, styles[`status-${status}`], className)}
      data-status={status}
      {...rest}
    >
      <span className={styles.icon} aria-hidden>
        {Camera ? <Camera size={24} /> : null}
      </span>
      <div className={styles.copy}>
        <p className={styles.label}>{label}</p>
        {showDescription && <p className={styles.description}>{description}</p>}
      </div>
      <ChipTag
        size="sm"
        intent={chip.intent}
        emphasis="strong"
        width="hug"
        label={chip.label}
        className={status === 'rejected' ? styles.rejectedChip : undefined}
      />
      {actionable && (
        <Button
          variant="text"
          size="sm"
          intent="primary"
          showLabel={false}
          showIcon
          icon="chevron-right-outline"
          aria-label={label}
          onClick={onAction}
        />
      )}
    </div>
  );
}
