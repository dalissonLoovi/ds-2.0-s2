import { describe, expect, it, vi, afterEach } from 'vitest';
import { cleanup, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ChipGroup } from './ChipGroup/ChipGroup';
import { ImageItem } from './ImageItem/ImageItem';
import { Modal } from './Modal/Modal';
import { ModalCheckItem } from './ModalCheckItem/ModalCheckItem';
import { ModalHeader } from './ModalHeader/ModalHeader';
import { PaginationSelectInput } from './PaginationSelectInput/PaginationSelectInput';
import { TableSkeleton } from './TableSkeleton/TableSkeleton';

afterEach(() => cleanup());

describe('ChipGroup', () => {
  it('exposes a named group of chips and marks the filter selection', () => {
    render(<ChipGroup type="filter" label="Filters" />);
    expect(screen.getByRole('group', { name: 'Filters' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Chip 01' })).toHaveAttribute('aria-pressed', 'true');
  });
});

describe('ImageItem', () => {
  it('shows overlay copy when photo text is on', () => {
    render(<ImageItem showPhotoTextItem overlayLabel="CNH" showOverlaySupportingText overlaySupportingText="Frente" />);
    expect(screen.getByText('CNH')).toBeInTheDocument();
    expect(screen.getByText('Frente')).toBeInTheDocument();
  });
});

describe('PaginationSelectInput', () => {
  it('opens the listbox and keeps the trigger named by value', async () => {
    const user = userEvent.setup();
    render(<PaginationSelectInput value="20" />);
    await user.click(screen.getByRole('button', { name: /20/ }));
    expect(screen.getByRole('listbox')).toBeInTheDocument();
  });
});

describe('TableSkeleton', () => {
  it('hides body bones when empty', () => {
    const { container, rerender } = render(<TableSkeleton empty={false} />);
    const full = container.querySelectorAll('[aria-hidden] span').length;
    rerender(<TableSkeleton empty />);
    const emptyCount = container.querySelectorAll('[aria-hidden] span').length;
    expect(emptyCount).toBeLessThan(full);
    expect(emptyCount).toBe(5);
  });
});

describe('ModalHeader', () => {
  it('names the close action in Portuguese', async () => {
    const user = userEvent.setup();
    const onClose = vi.fn();
    render(<ModalHeader title="Confirm" onClose={onClose} />);
    await user.click(screen.getByRole('button', { name: 'Fechar modal' }));
    expect(onClose).toHaveBeenCalled();
  });
});

describe('ModalCheckItem', () => {
  it('keeps the leading icon decorative', () => {
    render(<ModalCheckItem description="Wear a plain background." />);
    expect(screen.getByText('Wear a plain background.')).toBeInTheDocument();
    expect(screen.queryByRole('checkbox')).not.toBeInTheDocument();
  });
});

describe('Modal', () => {
  it('composes ModalHeader close control', () => {
    render(
      <Modal open title="Confirm">
        Body
      </Modal>,
    );
    expect(screen.getByRole('dialog')).toHaveAccessibleName('Confirm');
    expect(screen.getByRole('button', { name: 'Fechar modal' })).toBeInTheDocument();
  });
});
