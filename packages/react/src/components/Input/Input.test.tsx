import { describe, expect, it, afterEach } from 'vitest';
import { cleanup, render, screen } from '@testing-library/react';
import { Input } from './Input';

afterEach(() => cleanup());

describe('Input', () => {
  it('associates label and exposes supporting text', () => {
    render(
      <Input
        id="email"
        label="Email"
        supportingText="We'll never share it"
        showSupportingText
      />,
    );
    expect(screen.getByLabelText('Email')).toBeInTheDocument();
    expect(screen.getByText("We'll never share it")).toBeInTheDocument();
  });

  it('marks invalid when state=error', () => {
    render(<Input id="email-error" label="Email error" state="error" />);
    expect(screen.getByRole('textbox', { name: 'Email error' })).toHaveAttribute(
      'aria-invalid',
      'true',
    );
  });
});
