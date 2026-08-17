import figma from '@figma/code-connect';
import { Button } from './Button';

/**
 * Code Connect — Button
 * Figma node: 3104:3723
 */
figma.connect(
  Button,
  'https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3104-3723',
  {
    props: {
      label: figma.string('label'),
      variant: figma.enum('variant', {
        solid: 'solid',
        outline: 'outline',
        text: 'text',
      }),
      size: figma.enum('size', { sm: 'sm', md: 'md', lg: 'lg' }),
      intent: figma.enum('intent', {
        primary: 'primary',
        success: 'success',
        danger: 'danger',
        secondary: 'secondary',
      }),
      disabled: figma.boolean('disabled'),
      showIcon: figma.boolean('showIcon'),
      showLabel: figma.boolean('showLabel'),
      showTrailingIcon: figma.boolean('showTrailingIcon'),
    },
    example: (props) => (
      <Button
        label={props.label as string}
        variant={props.variant as 'solid' | 'outline' | 'text'}
        size={props.size as 'sm' | 'md' | 'lg'}
        intent={props.intent as 'primary' | 'success' | 'danger' | 'secondary'}
        disabled={Boolean(props.disabled)}
        showIcon={Boolean(props.showIcon)}
        showLabel={props.showLabel !== false}
        showTrailingIcon={Boolean(props.showTrailingIcon)}
      />
    ),
  },
);
