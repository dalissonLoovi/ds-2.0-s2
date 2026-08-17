import figma from '@figma/code-connect';
import { Autocomplete } from './Autocomplete';

/**
 * Code Connect — Autocomplete
 * Figma node: 3918:573
 */
figma.connect(
  Autocomplete,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3918-573',
  {
    example: () => <Autocomplete />,
  },
);
