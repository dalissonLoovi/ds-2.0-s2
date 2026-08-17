import figma from '@figma/code-connect';
import { Calendar } from './Calendar';

/**
 * Code Connect — Calendar
 * Figma node: 3982:5542
 */
figma.connect(
  Calendar,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3982-5542',
  {
    example: () => <Calendar />,
  },
);
