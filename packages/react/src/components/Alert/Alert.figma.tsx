import figma from '@figma/code-connect';
import { Alert } from './Alert';

figma.connect(
  Alert,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=4406-91',
  {
    props: {
      title: figma.string('title'),
      description: figma.string('description'),
      status: figma.enum('status', {
        system: 'system',
        info: 'info',
        success: 'success',
        danger: 'danger',
        warning: 'warning',
      }),
      appearance: figma.enum('appearance', { default: 'default', inverse: 'inverse' }),
      showDescription: figma.boolean('showDescription'),
      showAction: figma.boolean('showAction'),
    },
    example: (props) => <Alert {...props} />,
  },
);
