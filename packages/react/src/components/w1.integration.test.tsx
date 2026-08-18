import { describe, expect, it, vi, afterEach } from 'vitest';
import { cleanup, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Link } from './Link/Link';
import { Checkbox } from './Checkbox/Checkbox';
import { RadioButton } from './RadioButton/RadioButton';
import { Switch } from './Switch/Switch';
import { InputPassword } from './InputPassword/InputPassword';
import { InputSelect } from './InputSelect/InputSelect';
import { VerificationCodeInput } from './VerificationCodeInput/VerificationCodeInput';
import { DatePickerSelect } from './DatePickerSelect/DatePickerSelect';
import { SearchBar } from './SearchBar/SearchBar';

afterEach(() => cleanup());

describe('Link', () => {
  it('renders as a link and marks disabled', () => {
    const onClick = vi.fn();
    render(<Link label="Docs" href="/docs" disabled onClick={onClick} />);
    const link = screen.getByRole('link', { name: 'Docs' });
    expect(link).toHaveAttribute('aria-disabled', 'true');
    expect(link).toHaveAttribute('href', '/docs');
  });
});

describe('Checkbox', () => {
  it('supports mixed via aria-checked', () => {
    render(<Checkbox label="Select all" checked="mixed" readOnly />);
    expect(screen.getByRole('checkbox')).toHaveAttribute('aria-checked', 'mixed');
  });
});

describe('RadioButton', () => {
  it('toggles within a named group', async () => {
    const user = userEvent.setup();
    render(
      <>
        <RadioButton name="plan" label="A" />
        <RadioButton name="plan" label="B" />
      </>,
    );
    await user.click(screen.getByRole('radio', { name: 'B' }));
    expect(screen.getByRole('radio', { name: 'B' })).toBeChecked();
  });
});

describe('Switch', () => {
  it('toggles aria-checked', async () => {
    const user = userEvent.setup();
    const onCheckedChange = vi.fn();
    render(<Switch aria-label="Notify" onCheckedChange={onCheckedChange} />);
    const sw = screen.getByRole('switch', { name: 'Notify' });
    expect(sw).toHaveAttribute('aria-checked', 'false');
    await user.click(sw);
    expect(onCheckedChange).toHaveBeenCalledWith(true);
  });
});

describe('InputPassword', () => {
  it('reveals password text', async () => {
    const user = userEvent.setup();
    render(<InputPassword label="Password" defaultValue="secret" />);
    expect(screen.getByLabelText('Password')).toHaveAttribute('type', 'password');
    await user.click(screen.getByRole('button', { name: 'Mostrar senha' }));
    expect(screen.getByLabelText('Password')).toHaveAttribute('type', 'text');
  });
});

describe('InputSelect', () => {
  it('exposes combobox trigger semantics', () => {
    render(<InputSelect label="City" expanded listboxId="cities" />);
    const trigger = screen.getByRole('button', { name: 'City' });
    expect(trigger).toHaveAttribute('aria-expanded', 'true');
    expect(trigger).toHaveAttribute('aria-controls', 'cities');
  });
});

describe('SearchBar', () => {
  it('uses search landmark', () => {
    render(<SearchBar placeholder="Find" />);
    expect(screen.getByRole('search')).toBeInTheDocument();
  });
});

describe('VerificationCodeInput', () => {
  it('advances focus and reports digits', async () => {
    const user = userEvent.setup();
    const onDigitsChange = vi.fn();
    render(<VerificationCodeInput label="Code" onDigitsChange={onDigitsChange} />);
    const first = screen.getByLabelText('Digit 1');
    await user.type(first, '9');
    expect(onDigitsChange).toHaveBeenCalled();
    const last = onDigitsChange.mock.calls[onDigitsChange.mock.calls.length - 1]?.[0];
    expect(last[0]).toBe('9');
  });
});

describe('DatePickerSelect', () => {
  it('renders units for day-month-year', () => {
    render(<DatePickerSelect format="day-month-year" dayValue="12" monthValue="Aug" yearValue="2026" />);
    expect(screen.getByRole('button', { name: 'Day 12' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Month Aug' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Year 2026' })).toBeInTheDocument();
  });
});
