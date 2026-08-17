import { describe, expect, it, afterEach } from 'vitest';
import { cleanup, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { TextHeader } from './TextHeader/TextHeader';
import { SectionHeader } from './SectionHeader/SectionHeader';
import { TabsPrimary } from './TabsPrimary/TabsPrimary';
import { Breadcrumb } from './Breadcrumb/Breadcrumb';
import { NavigationBar } from './NavigationBar/NavigationBar';
import { AppHeader } from './AppHeader/AppHeader';
import { SystemHeader } from './SystemHeader/SystemHeader';
import { OrganizationHeader } from './OrganizationHeader/OrganizationHeader';

afterEach(() => cleanup());

describe('TextHeader', () => {
  it('renders heading by size', () => {
    render(<TextHeader size="large" title="Page title" />);
    expect(screen.getByRole('heading', { level: 1, name: 'Page title' })).toBeInTheDocument();
  });
});

describe('SectionHeader', () => {
  it('exposes icon-only action name', () => {
    render(<SectionHeader title="Vehicles" showAction actionLabel="See all" />);
    expect(screen.getByRole('button', { name: 'See all' })).toBeInTheDocument();
  });
});

describe('OrganizationHeader', () => {
  it('uses h1 for artifact title', () => {
    render(<OrganizationHeader title="Offer" />);
    expect(screen.getByRole('heading', { level: 1, name: 'Offer' })).toBeInTheDocument();
  });
});

describe('TabsPrimary', () => {
  it('marks selected tab', async () => {
    const user = userEvent.setup();
    let selected = 0;
    const { rerender } = render(
      <TabsPrimary itemCount="3" selectedIndex={selected} onSelect={(i) => (selected = i)} />,
    );
    expect(screen.getByRole('tab', { name: 'Tab 1' })).toHaveAttribute('aria-selected', 'true');
    await user.click(screen.getByRole('tab', { name: 'Tab 2' }));
    rerender(<TabsPrimary itemCount="3" selectedIndex={1} />);
    expect(screen.getByRole('tab', { name: 'Tab 2' })).toHaveAttribute('aria-selected', 'true');
  });
});

describe('Breadcrumb', () => {
  it('exposes nav landmark', () => {
    render(<Breadcrumb />);
    expect(screen.getByRole('navigation', { name: 'Breadcrumb' })).toBeInTheDocument();
  });
});

describe('NavigationBar', () => {
  it('marks current destination', () => {
    render(<NavigationBar itemCount="4" selectedIndex={0} />);
    expect(screen.getByRole('link', { name: 'Home' })).toHaveAttribute('aria-current', 'page');
  });
});

describe('AppHeader', () => {
  it('renders global greeting', () => {
    render(<AppHeader hierarchy="global" greeting="Olá, Maria" />);
    expect(screen.getByText('Olá, Maria')).toBeInTheDocument();
  });
});

describe('SystemHeader', () => {
  it('names notification action', () => {
    render(<SystemHeader title="Dashboard" />);
    expect(screen.getByRole('button', { name: 'Notificações' })).toBeInTheDocument();
  });
});
