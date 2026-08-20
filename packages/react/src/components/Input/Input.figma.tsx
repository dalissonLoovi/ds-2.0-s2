import figma from '@figma/code-connect';
import { Input } from './Input';

figma.connect(
  Input,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3873-334',
  {
    props: {
      label: figma.string('label'),
      supportingText: figma.string('supportingText'),
      showSupportingText: figma.boolean('showSupportingText'),
      appearance: figma.enum('appearance', { default: 'default', inverse: 'inverse' }),
      state: figma.enum('state', {
        default: 'default',
        hover: 'hover',
        focus: 'focus',
        error: 'error',
        disabled: 'disabled',
      }),
    },
    example: (props) => <Input {...props} />,
  },
);
