import figma from '@figma/code-connect';
import { TableSkeleton } from './TableSkeleton';

/**
 * Code Connect — TableSkeleton
 * Figma node: 3459:9331
 */
figma.connect(
  TableSkeleton,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3459-9331',
  {
    example: () => <TableSkeleton />,
  },
);
