import { useRef, useState, type DragEvent, type InputHTMLAttributes } from 'react';
import { cx } from '../../utils/cx';
import styles from './FileUploaderDropzoneItem.module.css';

export type FileUploaderDropzoneItemState = 'default' | 'drag-hover' | 'focus' | 'disabled';

export type FileUploaderDropzoneItemProps = Omit<
  InputHTMLAttributes<HTMLInputElement>,
  'size' | 'type' | 'disabled'
> & {
  state?: FileUploaderDropzoneItemState;
  helperText?: string;
  disabled?: boolean;
};

export function FileUploaderDropzoneItem({
  state = 'default',
  helperText = 'Arraste arquivos ou clique para selecionar',
  disabled = false,
  className,
  onChange,
  ...rest
}: FileUploaderDropzoneItemProps) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [dragging, setDragging] = useState(false);
  const isDisabled = disabled || state === 'disabled';
  const visual: FileUploaderDropzoneItemState = isDisabled
    ? 'disabled'
    : dragging
      ? 'drag-hover'
      : state;

  const openPicker = () => {
    if (isDisabled) return;
    inputRef.current?.click();
  };

  const onDragOver = (event: DragEvent<HTMLButtonElement>) => {
    event.preventDefault();
    if (isDisabled) return;
    setDragging(true);
  };

  const onDragLeave = () => setDragging(false);

  const onDrop = (event: DragEvent<HTMLButtonElement>) => {
    event.preventDefault();
    setDragging(false);
    if (isDisabled || !event.dataTransfer.files?.length) return;
    const input = inputRef.current;
    if (!input) return;
    const transfer = new DataTransfer();
    Array.from(event.dataTransfer.files).forEach((file) => transfer.items.add(file));
    input.files = transfer.files;
    input.dispatchEvent(new Event('change', { bubbles: true }));
  };

  return (
    <div className={cx(styles.root, styles[`state-${visual}`], className)} data-state={visual}>
      <input
        ref={inputRef}
        type="file"
        className={styles.input}
        disabled={isDisabled}
        tabIndex={-1}
        onChange={onChange}
        {...rest}
      />
      <button
        type="button"
        className={styles.dropzone}
        disabled={isDisabled}
        aria-disabled={isDisabled || undefined}
        tabIndex={isDisabled ? -1 : 0}
        aria-label={helperText}
        onClick={openPicker}
        onDragOver={onDragOver}
        onDragLeave={onDragLeave}
        onDrop={onDrop}
      >
        <span className={styles.helper}>{helperText}</span>
      </button>
    </div>
  );
}
