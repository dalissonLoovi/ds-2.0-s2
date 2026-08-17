import figma from '@figma/code-connect';
import { ChipClickable } from './ChipClickable';

figma.connect(
  ChipClickable,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3653-23577',
  {
    props: {
      label: figma.string('label'),
      intent: figma.enum('intent', {
        info: 'info',
        system: 'system',
        success: 'success',
        warning: 'warning',
        danger: 'danger',
        outline: 'outline',
        soft: 'soft',
      }),
      size: figma.enum('size', { sm: 'sm', md: 'md' }),
      showLeadingIcon: figma.boolean('showLeadingIcon'),
    },
    example: (props) => <ChipClickable {...props} />,
  },
);
