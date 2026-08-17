import figma from '@figma/code-connect';
import { FileUploader } from './FileUploader';

/**
 * Code Connect — FileUploader
 * Figma node: 3581:4454
 */
figma.connect(
  FileUploader,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3581-4454',
  {
    example: () => <FileUploader />,
  },
);
