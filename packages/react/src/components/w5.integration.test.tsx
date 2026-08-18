import { describe, expect, it, vi, afterEach } from 'vitest';
import { cleanup, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { CardStacked } from './CardStacked/CardStacked';
import { CardHorizontal } from './CardHorizontal/CardHorizontal';
import { DashboardCardPrimary } from './DashboardCardPrimary/DashboardCardPrimary';
import { DashboardCardSecondary } from './DashboardCardSecondary/DashboardCardSecondary';
import { FeatureSteps } from './FeatureSteps/FeatureSteps';
import { OfferProductCard } from './OfferProductCard/OfferProductCard';
import { QuickAccessTile } from './QuickAccessTile/QuickAccessTile';
import { ReferralDiscountCard } from './ReferralDiscountCard/ReferralDiscountCard';
import { UploadPhotos } from './UploadPhotos/UploadPhotos';
import { VehicleConfirmCard } from './VehicleConfirmCard/VehicleConfirmCard';
import { VehicleSummaryCard } from './VehicleSummaryCard/VehicleSummaryCard';

afterEach(() => cleanup());

describe('CardStacked', () => {
  it('names the card from header and exposes actions', () => {
    render(<CardStacked headerText="Offer" titleText="Coverage" />);
    expect(screen.getByText('Offer')).toBeInTheDocument();
    expect(screen.getAllByRole('button', { name: 'Action' }).length).toBeGreaterThan(0);
  });
});

describe('CardHorizontal', () => {
  it('renders header copy', () => {
    render(<CardHorizontal headerText="Driver" subheadText="Online" />);
    expect(screen.getByText('Driver')).toBeInTheDocument();
    expect(screen.getByText('Online')).toBeInTheDocument();
  });
});

describe('DashboardCardPrimary', () => {
  it('exposes the primary metric', () => {
    render(<DashboardCardPrimary title="Receita" primaryValue="R$ 12.000" />);
    expect(screen.getByText('Receita')).toBeInTheDocument();
    expect(screen.getByText('R$ 12.000')).toBeInTheDocument();
  });
});

describe('DashboardCardSecondary', () => {
  it('shows growth percentage', () => {
    render(<DashboardCardSecondary title="Corridas" value="128" growth="up" percentage="12%" />);
    expect(screen.getByText('128')).toBeInTheDocument();
    expect(screen.getByText('12%')).toBeInTheDocument();
  });
});

describe('QuickAccessTile', () => {
  it('exposes a named button and can be disabled', () => {
    render(<QuickAccessTile label="Pagar boleto" state="disabled" />);
    expect(screen.getByRole('button', { name: 'Pagar boleto' })).toBeDisabled();
  });
});

describe('OfferProductCard', () => {
  it('fires the nested CTA', async () => {
    const user = userEvent.setup();
    const onCta = vi.fn();
    render(<OfferProductCard title="Seguro" ctaLabel="Contratar" onCta={onCta} />);
    await user.click(screen.getByRole('button', { name: 'Contratar' }));
    expect(onCta).toHaveBeenCalled();
  });
});

describe('ReferralDiscountCard', () => {
  it('keeps the invite CTA in fleet mode without a progressbar', async () => {
    const user = userEvent.setup();
    const onInvite = vi.fn();
    render(<ReferralDiscountCard mode="fleet" onInvite={onInvite} />);
    expect(screen.queryByRole('progressbar')).not.toBeInTheDocument();
    await user.click(screen.getByRole('button', { name: 'Convidar' }));
    expect(onInvite).toHaveBeenCalled();
  });
});

describe('VehicleSummaryCard', () => {
  it('shows status text for the default appearance', () => {
    render(<VehicleSummaryCard appearance="default" status="inactive" plate="ABC1D23" />);
    expect(screen.getByText('Inativo')).toBeInTheDocument();
    expect(screen.getByText('ABC1D23')).toBeInTheDocument();
  });
});

describe('VehicleConfirmCard', () => {
  it('renders plate as the hero identifier', () => {
    render(<VehicleConfirmCard plate="ABC1D23" brandModel="Fiat Palio" />);
    expect(screen.getByText('ABC1D23')).toBeInTheDocument();
    expect(screen.getByText('Fiat Palio')).toBeInTheDocument();
  });
});

describe('UploadPhotos', () => {
  it('keeps the chevron action named by the task label', async () => {
    const user = userEvent.setup();
    const onAction = vi.fn();
    render(<UploadPhotos status="pending" label="CNH frente" onAction={onAction} />);
    await user.click(screen.getByRole('button', { name: 'CNH frente' }));
    expect(onAction).toHaveBeenCalled();
  });
});

describe('FeatureSteps', () => {
  it('renders illustrative steps as a list', () => {
    render(<FeatureSteps />);
    expect(screen.getByRole('list')).toBeInTheDocument();
    expect(screen.getByText('Permissões')).toBeInTheDocument();
    expect(screen.getByText('Confirmar Veículo')).toBeInTheDocument();
  });
});
