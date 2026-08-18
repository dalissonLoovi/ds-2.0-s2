import { describe, expect, it, vi, afterEach } from 'vitest';
import { cleanup, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ChipTag } from './ChipTag/ChipTag';
import { ChipClickable } from './ChipClickable/ChipClickable';
import { Alert } from './Alert/Alert';
import { Toast } from './Toast/Toast';
import { Modal } from './Modal/Modal';

afterEach(() => cleanup());

describe('ChipTag', () => {
  it('renders soft success label', () => {
    render(<ChipTag label="Ativo" intent="success" emphasis="soft" showLeadingIcon />);
    expect(screen.getByText('Ativo')).toBeInTheDocument();
  });
});

describe('ChipClickable', () => {
  it('toggles selected via aria-pressed', async () => {
    const user = userEvent.setup();
    const onClick = vi.fn();
    render(<ChipClickable label="Filter" selected onClick={onClick} />);
    const btn = screen.getByRole('button', { name: 'Filter' });
    expect(btn).toHaveAttribute('aria-pressed', 'true');
    await user.click(btn);
    expect(onClick).toHaveBeenCalled();
  });
});

describe('Alert', () => {
  it('exposes status role and title', () => {
    render(<Alert status="success" title="Saved" showAction={false} />);
    expect(screen.getByRole('status')).toHaveTextContent('Saved');
  });
});

describe('Toast', () => {
  it('renders dismiss control', () => {
    render(<Toast message="Done" dismissible />);
    expect(screen.getByRole('button', { name: 'Dismiss' })).toBeInTheDocument();
  });
});

describe('Modal', () => {
  it('renders dialog with title when open', () => {
    render(
      <Modal open title="Confirm">
        Body
      </Modal>,
    );
    expect(screen.getByRole('dialog')).toHaveAccessibleName('Confirm');
  });

  it('calls onClose on Escape and locks body scroll', async () => {
    const user = userEvent.setup();
    const onClose = vi.fn();
    render(
      <Modal open title="Confirm" onClose={onClose}>
        Body
      </Modal>,
    );
    expect(document.body.style.overflow).toBe('hidden');
    await user.keyboard('{Escape}');
    expect(onClose).toHaveBeenCalledTimes(1);
  });
});
