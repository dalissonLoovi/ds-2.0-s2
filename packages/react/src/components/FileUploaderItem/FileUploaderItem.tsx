import type { HTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import { resolveIcon } from '../../icons/dsIcons';
import { Button } from '../Button/Button';
import { LoadingSpinner } from '../LoadingSpinner/LoadingSpinner';
import styles from './FileUploaderItem.module.css';

export type FileUploaderItemSize = 'sm' | 'md' | 'lg';
export type FileUploaderItemState =
  | 'uploaded'
  | 'loading'
  | 'success'
  | 'focus'
  | 'danger-short'
  | 'danger-long';

export type FileUploaderItemProps = HTMLAttributes<HTMLDivElement> & {
  size?: FileUploaderItemSize;
  state?: FileUploaderItemState;
  fileName?: string;
  shortDescription?: string;
  longDescription?: string;
  onRemove?: () => void;
};

export function FileUploaderItem({
  size = 'sm',
  state = 'uploaded',
  fileName = 'document.pdf',
  shortDescription = 'Arquivo inválido',
  longDescription = 'Envie um PDF de até 10 MB.',
  onRemove,
  className,
  ...rest
}: FileUploaderItemProps) {
  const FileIcon = resolveIcon('file-outline');
  const Success = resolveIcon('circle-check-filled');
  const Danger = resolveIcon('alert-circle-filled');
  const isDanger = state === 'danger-short' || state === 'danger-long';
  const live = state === 'loading' || state === 'success';

  return (
    <div
      className={cx(styles.root, styles[`size-${size}`], styles[`state-${state}`], className)}
      data-size={size}
      data-state={state}
      role={isDanger ? 'alert' : undefined}
      aria-live={live ? 'polite' : undefined}
      {...rest}
    >
      <span className={styles.leading} aria-hidden>
        {state === 'loading' ? (
          <LoadingSpinner size="sm" decorative />
        ) : state === 'success' && Success ? (
          <Success size={20} className={styles.success} />
        ) : isDanger && Danger ? (
          <Danger size={20} className={styles.danger} />
        ) : FileIcon ? (
          <FileIcon size={20} />
        ) : null}
      </span>
      <div className={styles.body}>
        <p className={styles.fileName}>{fileName}</p>
        {isDanger && <p className={styles.short}>{shortDescription}</p>}
        {state === 'danger-long' && <p className={styles.long}>{longDescription}</p>}
      </div>
      <Button
        variant="text"
        size="sm"
        intent="primary"
        showLabel={false}
        showIcon
        icon="x-outline"
        aria-label={`Remover ${fileName}`}
        className={cx(styles.remove, state === 'focus' && styles.removeFocus)}
        onClick={onRemove}
      />
    </div>
  );
}
