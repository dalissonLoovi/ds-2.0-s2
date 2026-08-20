import figma from '@figma/code-connect';
import { LoadingSpinner } from './LoadingSpinner';

/**
 * Code Connect — LoadingSpinner
 * Figma node: 3062:745
 */
figma.connect(
  LoadingSpinner,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3062-745',
  {
    example: () => <LoadingSpinner />,
  },
);
