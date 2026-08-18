import { useId, useRef, type InputHTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { Button, type ButtonSize } from '../Button/Button';
import { FileUploaderDropzoneItem } from '../FileUploaderDropzoneItem/FileUploaderDropzoneItem';
import { FileUploaderList } from '../FileUploaderList/FileUploaderList';
import styles from './FileUploader.module.css';

export type FileUploaderVariant = 'default' | 'drag-and-drop';
export type FileUploaderSize = 'lg' | 'md' | 'sm';
export type FileUploaderState = 'default' | 'disabled' | 'skeleton';

export type FileUploaderProps = Omit<
  InputHTMLAttributes<HTMLInputElement>,
  'size' | 'type' | 'disabled'
> & {
  variant?: FileUploaderVariant;
  size?: FileUploaderSize;
  state?: FileUploaderState;
  label?: string;
  description?: string;
  showFiles?: boolean;
  disabled?: boolean;
  children?: ReactNode;
};

export function FileUploader({
  variant = 'default',
  size = 'lg',
  state = 'default',
  label = 'Arquivos',
  description = 'PDF ou JPG de até 10 MB.',
  showFiles = true,
  disabled = false,
  children,
  className,
  id,
  onChange,
  ...rest
}: FileUploaderProps) {
  const autoId = useId();
  const inputId = id ?? autoId;
  const descId = `${inputId}-desc`;
  const inputRef = useRef<HTMLInputElement>(null);
  const isDisabled = disabled || state === 'disabled';
  const isSkeleton = state === 'skeleton';
  const buttonSize: ButtonSize = size;
  const showList = state === 'default' && showFiles;

  if (isSkeleton) {
    return (
      <div
        className={cx(styles.root, styles.skeleton, className)}
        data-variant={variant}
        data-size={size}
        data-state="skeleton"
        aria-busy
        aria-label={label}
      >
        <span className={cx(styles.bone, styles.boneLabel)} />
        <span className={cx(styles.bone, styles.boneDesc)} />
        <span className={cx(styles.bone, styles.boneAction)} />
      </div>
    );
  }

  return (
    <div
      className={cx(styles.root, isDisabled && styles.disabled, className)}
      data-variant={variant}
      data-size={size}
      data-state={isDisabled ? 'disabled' : state}
    >
      <div className={styles.header}>
        <label className={styles.label} htmlFor={inputId}>
          {label}
        </label>
        <p id={descId} className={styles.description}>
          {description}
        </p>
      </div>
      {variant === 'drag-and-drop' ? (
        <FileUploaderDropzoneItem
          id={inputId}
          state={isDisabled ? 'disabled' : 'default'}
          disabled={isDisabled}
          helperText="Arraste arquivos ou clique para selecionar"
          aria-describedby={descId}
          onChange={onChange}
          {...rest}
        />
      ) : (
        <>
          <input
            ref={inputRef}
            id={inputId}
            type="file"
            className={styles.input}
            disabled={isDisabled}
            aria-describedby={descId}
            onChange={onChange}
            {...rest}
          />
          <Button
            variant="solid"
            intent="primary"
            size={buttonSize}
            label="Selecionar arquivo"
            showIcon
            icon="upload-outline"
            disabled={isDisabled}
            onClick={() => inputRef.current?.click()}
          />
        </>
      )}
      {showList && (children ?? <FileUploaderList itemSize={size} aria-label="Arquivos selecionados" />)}
    </div>
  );
}
