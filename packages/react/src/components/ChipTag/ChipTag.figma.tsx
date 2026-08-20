import figma from '@figma/code-connect';
import { ChipTag } from './ChipTag';

figma.connect(
  ChipTag,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3653-23220',
  {
    props: {
      label: figma.string('label'),
      size: figma.enum('size', { sm: 'sm', md: 'md' }),
      intent: figma.enum('intent', {
        info: 'info',
        system: 'system',
        success: 'success',
        warning: 'warning',
        danger: 'danger',
        outline: 'outline',
      }),
      emphasis: figma.enum('emphasis', { strong: 'strong', soft: 'soft' }),
      showLeadingIcon: figma.boolean('showLeadingIcon'),
    },
    example: (props) => <ChipTag {...props} />,
  },
);
