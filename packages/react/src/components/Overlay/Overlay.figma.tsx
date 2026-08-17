import figma from '@figma/code-connect';
import { Overlay } from './Overlay';

/**
 * Code Connect — Overlay
 * Figma node: 3768:3886
 */
figma.connect(
  Overlay,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3768-3886',
  {
    example: () => <Overlay />,
  },
);
