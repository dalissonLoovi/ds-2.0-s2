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

  it('always shows error trailing icon regardless of trailingIcon', () => {
    render(<Input id="err" label="Field" state="error" trailingIcon={false} />);
    const field = screen.getByRole('textbox', { name: 'Field' }).closest('[data-state]');
    expect(field).toHaveAttribute('data-state', 'error');
    expect(document.querySelector('svg')).toBeTruthy();
  });

  it('uses floated label for content=placeholder', () => {
    render(<Input id="ph" label="Email" content="placeholder" placeholder="Type here" />);
    const root = screen.getByRole('textbox').closest('[data-content="placeholder"]');
    expect(root).toBeTruthy();
    expect(screen.getByText('Email', { selector: 'label' })).toBeInTheDocument();
  });

  it('uses resting label for content=label', () => {
    render(<Input id="rest" label="Email" content="label" state="default" />);
    const root = screen.getByRole('textbox').closest('[data-content="label"]');
    expect(root).toBeTruthy();
    expect(screen.getAllByText('Email')).toHaveLength(1);
  });
});
