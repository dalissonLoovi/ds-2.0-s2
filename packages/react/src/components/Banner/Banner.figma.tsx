import figma from '@figma/code-connect';
import { Banner } from './Banner';

/**
 * Code Connect — Banner
 * Figma node: 3098:2629
 */
figma.connect(
  Banner,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3098-2629',
  {
    example: () => <Banner />,
  },
);
