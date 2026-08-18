import { describe, expect, it, vi, afterEach } from 'vitest';
import { cleanup, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { LoadingSpinner } from './LoadingSpinner/LoadingSpinner';
import { Badge } from './Badge/Badge';
import { ProgressBar } from './ProgressBar/ProgressBar';
import { Banner } from './Banner/Banner';
import { Tooltip } from './Tooltip/Tooltip';
import { BottomSheet } from './BottomSheet/BottomSheet';
import { BottomSheetCheckItem } from './BottomSheetCheckItem/BottomSheetCheckItem';
import { Overlay } from './Overlay/Overlay';

afterEach(() => cleanup());

describe('LoadingSpinner', () => {
  it('announces loading status', () => {
    render(<LoadingSpinner label="Loading" />);
    expect(screen.getByRole('status', { name: 'Loading' })).toBeInTheDocument();
  });
});

describe('Badge', () => {
  it('renders count content', () => {
    render(<Badge content="count" count={8} />);
    expect(screen.getByLabelText('8')).toHaveTextContent('8');
  });
});

describe('ProgressBar', () => {
  it('exposes progressbar semantics', () => {
    render(<ProgressBar progress={55} showValue />);
    const bar = screen.getByRole('progressbar');
    expect(bar).toHaveAttribute('aria-valuenow', '55');
    expect(screen.getByText('55%')).toBeInTheDocument();
  });
});

describe('Banner', () => {
  it('uses alert role for danger and fires action', async () => {
    const user = userEvent.setup();
    const onAction = vi.fn();
    render(
      <Banner status="danger" message="Failed" showAction actionLabel="Retry" onAction={onAction} />,
    );
    expect(screen.getByRole('alert')).toHaveTextContent('Failed');
    await user.click(screen.getByRole('button', { name: 'Retry' }));
    expect(onAction).toHaveBeenCalled();
  });
});

describe('Tooltip', () => {
  it('shows description when open', () => {
    render(
      <Tooltip description="Tip text" open>
        <button type="button">Target</button>
      </Tooltip>,
    );
    expect(screen.getByRole('tooltip')).toHaveTextContent('Tip text');
  });
});

describe('BottomSheet', () => {
  it('closes on Escape', async () => {
    const user = userEvent.setup();
    const onClose = vi.fn();
    render(
      <BottomSheet open title="Filters" onClose={onClose}>
        Content
      </BottomSheet>,
    );
    expect(screen.getByRole('dialog')).toHaveAccessibleName('Filters');
    await user.keyboard('{Escape}');
    expect(onClose).toHaveBeenCalled();
  });
});

describe('BottomSheetCheckItem', () => {
  it('renders guideline text', () => {
    render(
      <ul>
        <BottomSheetCheckItem description="Bring documents" />
      </ul>,
    );
    expect(screen.getByText('Bring documents')).toBeInTheDocument();
  });
});

describe('Overlay', () => {
  it('renders slot content with type/platform', () => {
    render(
      <Overlay type="modal" platform="web" open>
        <div>Panel</div>
      </Overlay>,
    );
    expect(screen.getByText('Panel')).toBeInTheDocument();
  });
});
