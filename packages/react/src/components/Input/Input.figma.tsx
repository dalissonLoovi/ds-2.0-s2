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
      content: figma.enum('content', {
        value: 'value',
        placeholder: 'placeholder',
        label: 'label',
      }),
      leadingIcon: figma.boolean('leadingIcon'),
      trailingIcon: figma.boolean('trailingIcon'),
    },
    example: (props) => (
      <Input
        label={props.label as string}
        supportingText={props.supportingText as string}
        showSupportingText={props.showSupportingText !== false}
        appearance={props.appearance as 'default' | 'inverse'}
        state={props.state as 'default' | 'hover' | 'focus' | 'error' | 'disabled'}
        content={props.content as 'value' | 'placeholder' | 'label'}
        leadingIcon={Boolean(props.leadingIcon)}
        trailingIcon={Boolean(props.trailingIcon)}
      />
    ),
  },
);
