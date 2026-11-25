import { afterEach, describe, expect, it } from 'vitest';
import { cleanup, render, screen, waitFor } from '@testing-library/react';
import { illustrationLoaders, illustrationNames, illustrations } from '../../illustrations';
import { ListItemLeadingIllustration } from '../ListItemLeadingIllustration/ListItemLeadingIllustration';
import { ListItemTrailingIllustration } from '../ListItemTrailingIllustration/ListItemTrailingIllustration';
import { VehicleSummaryCard } from '../VehicleSummaryCard/VehicleSummaryCard';
import { Illustration, illustrationSize, resolveIllustrationName } from './Illustration';

afterEach(cleanup);

describe('illustration catalog', () => {
  it('has 60 kebab-case <group>/<name> entries', () => {
    expect(illustrationNames).toHaveLength(60);
    for (const n of illustrationNames) {
      expect(n).toMatch(/^[a-z0-9]+(-[a-z0-9]+)*\/[a-z0-9]+(-[a-z0-9]+)*$/);
      expect(illustrations[n].group).toBe(n.split('/')[0]);
    }
  });

  it('every name loads an SVG whose viewBox matches the artboard', async () => {
    for (const n of illustrationNames) {
      const { default: svg } = await illustrationLoaders[n]();
      const { width, height } = illustrations[n];
      expect(svg.startsWith('<svg'), n).toBe(true);
      expect(svg, n).toContain(`viewBox="0 0 ${width} ${height}"`);
    }
  });

  it('resolves slot slugs', () => {
    expect(resolveIllustrationName('sedan')).toBe('vehicle-icon/sedan');
    expect(resolveIllustrationName('claim-reason/theft')).toBe('claim-reason/theft');
    expect(resolveIllustrationName('theft')).toBe('claim-reason/theft');
    expect(resolveIllustrationName('not-in-catalog')).toBeNull();
    expect(resolveIllustrationName(null)).toBeNull();
  });

  it('keeps the artboard ratio when only one side is given', () => {
    expect(illustrationSize('card/cred-card-1', 164)).toEqual({ width: 164, height: 100 });
    expect(illustrationSize('claim-reason/theft')).toEqual({ width: 156, height: 156 });
  });
});

describe('Illustration', () => {
  it('is decorative by default', async () => {
    const { container } = render(<Illustration name="claim-reason/theft" width={48} />);
    await waitFor(() => expect(container.querySelector('img')).not.toBeNull());
    const img = container.querySelector('img')!;
    expect(img).toHaveAttribute('alt', '');
    expect(img).toHaveAttribute('aria-hidden', 'true');
    expect(img.getAttribute('src')).toMatch(/^data:image\/svg\+xml/);
    expect(img).toHaveAttribute('width', '48');
    expect(img).toHaveAttribute('height', '48');
  });

  it('exposes alt text when given', async () => {
    render(<Illustration name="feedback/success" alt="Sucesso" />);
    // Labelled while loading (placeholder) and once the <img> is in.
    expect(screen.getByRole('img', { name: 'Sucesso' })).toBeInTheDocument();
    await waitFor(() => expect(screen.getByRole('img', { name: 'Sucesso' }).tagName).toBe('IMG'));
  });
});

describe('slots render catalog art', () => {
  it('ListItemLeading/TrailingIllustration resolve illustrationAsset', async () => {
    const { container } = render(
      <>
        <ListItemLeadingIllustration />
        <ListItemTrailingIllustration illustrationAsset="claim-reason/door-damage" />
        <ListItemLeadingIllustration illustrationAsset="unknown-art" data-testid="unknown" />
      </>,
    );
    await waitFor(() => expect(container.querySelectorAll('img')).toHaveLength(2));
    expect(container.querySelector('[data-illustration="vehicle-icon/sedan"]')).not.toBeNull();
    expect(container.querySelector('[data-illustration="claim-reason/door-damage"]')).not.toBeNull();
    expect(screen.getByTestId('unknown')).toBeEmptyDOMElement();
  });

  it('VehicleSummaryCard draws the vehicle art', async () => {
    const { container } = render(<VehicleSummaryCard illustrationAsset="suv" />);
    await waitFor(() => expect(container.querySelector('img[data-illustration="vehicle-icon/suv"]')).not.toBeNull());
  });
});
