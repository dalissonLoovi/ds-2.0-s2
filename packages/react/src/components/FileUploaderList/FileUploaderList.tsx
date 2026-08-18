import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { FileUploaderItem, type FileUploaderItemSize } from '../FileUploaderItem/FileUploaderItem';
import styles from './FileUploaderList.module.css';

export type FileUploaderListProps = HTMLAttributes<HTMLDivElement> & {
  showFileItem02?: boolean;
  showFileItem03?: boolean;
  showFileItem04?: boolean;
  showFileItem05?: boolean;
  showFileItem06?: boolean;
  showFileItem07?: boolean;
  itemSize?: FileUploaderItemSize;
  children?: ReactNode;
};

const DEMO = [
  { fileName: 'cnh.pdf', state: 'uploaded' as const },
  { fileName: 'comprovante.pdf', state: 'loading' as const },
  { fileName: 'selfie.jpg', state: 'success' as const },
  { fileName: 'crlv.pdf', state: 'focus' as const },
  { fileName: 'contrato.pdf', state: 'danger-short' as const },
  { fileName: 'laudo.pdf', state: 'danger-long' as const },
  { fileName: 'extra.pdf', state: 'uploaded' as const },
];

export function FileUploaderList({
  showFileItem02 = true,
  showFileItem03 = true,
  showFileItem04 = false,
  showFileItem05 = false,
  showFileItem06 = false,
  showFileItem07 = false,
  itemSize = 'sm',
  children,
  className,
  ...rest
}: FileUploaderListProps) {
  const flags = [true, showFileItem02, showFileItem03, showFileItem04, showFileItem05, showFileItem06, showFileItem07];

  return (
    <div className={cx(styles.root, className)} role="list" {...rest}>
      {children ??
        DEMO.filter((_, index) => flags[index]).map((item) => (
          <div key={item.fileName} className={styles.item} role="listitem">
            <FileUploaderItem size={itemSize} state={item.state} fileName={item.fileName} />
          </div>
        ))}
    </div>
  );
}
