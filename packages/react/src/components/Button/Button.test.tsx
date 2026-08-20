import { describe, expect, it, vi, afterEach } from 'vitest';
import { cleanup, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Button } from './Button';

afterEach(() => cleanup());

describe('Button', () => {
  it('renders label and activates on click', async () => {
    const user = userEvent.setup();
    const onClick = vi.fn();
    render(<Button label="Save" onClick={onClick} />);
    const btn = screen.getByRole('button', { name: 'Save' });
    await user.click(btn);
    expect(onClick).toHaveBeenCalledTimes(1);
  });

  it('exposes busy and blocks activation while loading', async () => {
    const user = userEvent.setup();
    const onClick = vi.fn();
    render(<Button label="Uploading" loading onClick={onClick} />);
    const btn = screen.getByRole('button', { name: 'Uploading' });
    expect(btn).toHaveAttribute('aria-busy', 'true');
    expect(btn).toBeDisabled();
    await user.click(btn);
    expect(onClick).not.toHaveBeenCalled();
  });

  it('blocks activation when disabled', async () => {
    const user = userEvent.setup();
    const onClick = vi.fn();
    render(<Button label="Save" disabled onClick={onClick} />);
    const btn = screen.getByRole('button', { name: 'Save' });
    expect(btn).toBeDisabled();
    await user.click(btn);
    expect(onClick).not.toHaveBeenCalled();
  });
});
