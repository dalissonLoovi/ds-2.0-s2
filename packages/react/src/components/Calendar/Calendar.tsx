import { useId, useMemo, useState, type HTMLAttributes, type ReactNode } from 'react';
import { cx } from '../../utils/cx';
import { Button } from '../Button/Button';
import { CalendarDay, type CalendarDayKind, type CalendarDayState } from '../CalendarDay/CalendarDay';
import { CalendarPeriodNav } from '../CalendarPeriodNav/CalendarPeriodNav';
import { DatePickerSelect } from '../DatePickerSelect/DatePickerSelect';
import { DividerHorizontal } from '../DividerHorizontal/DividerHorizontal';
import { DividerVertical } from '../DividerVertical/DividerVertical';
import { ListActionDropdownItem } from '../ListActionDropdownItem/ListActionDropdownItem';
import styles from './Calendar.module.css';

export type CalendarMode = 'simple' | 'month' | 'month-year' | 'complete' | 'time';
export type CalendarPicker = 'default' | 'month' | 'year';
export type CalendarPlatform = 'mobile' | 'web';

export type CalendarProps = HTMLAttributes<HTMLDivElement> & {
  mode?: CalendarMode;
  picker?: CalendarPicker;
  platform?: CalendarPlatform;
  monthTitle?: string;
  showSelectItems?: boolean;
  viewYear?: number;
  viewMonth?: number;
  selected?: string;
  rangeStart?: string;
  rangeEnd?: string;
  onSelect?: (isoDate: string) => void;
  onClear?: () => void;
  onCancel?: () => void;
  onConfirm?: () => void;
  children?: ReactNode;
};

const WEEKDAYS = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
const MONTHS = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];
const MONTH_SHORT = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
const PRESETS = ['Hoje', 'Ontem', 'Esta semana', 'Este mês', 'Personalizado'];
const HOURS = ['08', '09', '10', '11', '12', '13'];
const MINUTES = ['00', '15', '30', '45'];

function pad(value: number) {
  return String(value).padStart(2, '0');
}

function iso(year: number, month: number, day: number) {
  return `${year}-${pad(month)}-${pad(day)}`;
}

function shiftMonth(year: number, month: number, delta: number) {
  const date = new Date(year, month - 1 + delta, 1);
  return { year: date.getFullYear(), month: date.getMonth() + 1 };
}

type GridCell = {
  iso: string;
  day: string;
  kind: CalendarDayKind;
  state: CalendarDayState;
};

function buildGrid(
  year: number,
  month: number,
  selected?: string,
  rangeStart?: string,
  rangeEnd?: string,
): GridCell[] {
  const first = new Date(year, month - 1, 1);
  const startOffset = first.getDay();
  const daysInMonth = new Date(year, month, 0).getDate();
  const today = new Date();
  const todayIso = iso(today.getFullYear(), today.getMonth() + 1, today.getDate());
  const cells: GridCell[] = [];

  for (let index = 0; index < 42; index += 1) {
    const dayNumber = index - startOffset + 1;
    const date = new Date(year, month - 1, dayNumber);
    const cellIso = iso(date.getFullYear(), date.getMonth() + 1, date.getDate());
    const inMonth = dayNumber >= 1 && dayNumber <= daysInMonth;
    let kind: CalendarDayKind = inMonth ? 'default' : 'outside';
    let state: CalendarDayState = 'default';

    if (rangeStart && rangeEnd) {
      if (cellIso === rangeStart) kind = 'range-start';
      else if (cellIso === rangeEnd) kind = 'range-end';
      else if (cellIso > rangeStart && cellIso < rangeEnd) kind = 'range-middle';
    }

    if (selected === cellIso || (!rangeStart && cellIso === selected)) {
      state = 'selected';
    }
    if (cellIso === todayIso && inMonth && state !== 'selected' && kind === 'default') {
      kind = 'today';
    }
    if (!inMonth && kind === 'default') kind = 'outside';

    cells.push({ iso: cellIso, day: String(date.getDate()), kind, state });
  }
  return cells;
}

function MonthGrid({
  year,
  month,
  selected,
  rangeStart,
  rangeEnd,
  onSelect,
  labelledBy,
}: {
  year: number;
  month: number;
  selected?: string;
  rangeStart?: string;
  rangeEnd?: string;
  onSelect?: (isoDate: string) => void;
  labelledBy?: string;
}) {
  const cells = useMemo(
    () => buildGrid(year, month, selected, rangeStart, rangeEnd),
    [year, month, selected, rangeStart, rangeEnd],
  );

  return (
    <div className={styles.grid} role="grid" aria-labelledby={labelledBy}>
      <div className={styles.weekdays} role="row">
        {WEEKDAYS.map((label, index) => (
          <span key={`${label}-${index}`} className={styles.weekday} role="columnheader">
            {label}
          </span>
        ))}
      </div>
      <div className={styles.days}>
        {Array.from({ length: 6 }, (_, week) => (
          <div key={week} className={styles.week} role="row">
            {cells.slice(week * 7, week * 7 + 7).map((cell) => (
              <CalendarDay
                key={cell.iso}
                day={cell.day}
                kind={cell.kind}
                state={cell.state}
                aria-label={cell.iso}
                onClick={() => onSelect?.(cell.iso)}
              />
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}

export function Calendar({
  mode = 'simple',
  picker = 'default',
  platform = 'mobile',
  monthTitle,
  showSelectItems = false,
  viewYear: viewYearProp,
  viewMonth: viewMonthProp,
  selected: selectedProp,
  rangeStart,
  rangeEnd,
  onSelect,
  onClear,
  onCancel,
  onConfirm,
  className,
  children,
  ...rest
}: CalendarProps) {
  const [view, setView] = useState(() => ({
    year: viewYearProp ?? 2025,
    month: viewMonthProp ?? 9,
  }));
  const [internalSelected, setInternalSelected] = useState(selectedProp ?? '2025-09-10');
  const selected = selectedProp ?? internalSelected;
  const year = viewYearProp ?? view.year;
  const month = viewMonthProp ?? view.month;
  const title = monthTitle ?? `${MONTHS[month - 1]} de ${year}`;
  const titleId = useId();
  const showPresets = mode === 'complete' && platform === 'web' && showSelectItems;
  const nextMonth = shiftMonth(year, month, 1);
  const dual = mode === 'complete' && platform === 'mobile';

  const selectDate = (isoDate: string) => {
    if (selectedProp === undefined) setInternalSelected(isoDate);
    onSelect?.(isoDate);
  };

  const step = (delta: number) => {
    if (viewYearProp != null) return;
    setView((current) => shiftMonth(current.year, current.month, delta));
  };

  return (
    <div
      className={cx(styles.root, styles[`platform-${platform}`], styles[`mode-${mode}`], className)}
      role="dialog"
      aria-label="Calendar"
      data-mode={mode}
      data-picker={picker}
      data-platform={platform}
      {...rest}
    >
      {children ?? (
        <>
          <div className={styles.panel}>
            {mode === 'simple' && (
              <p id={titleId} className={styles.monthTitle}>
                {title}
              </p>
            )}
            {mode === 'month' || mode === 'complete' ? (
              <CalendarPeriodNav
                periodLabel={title}
                onPrevious={() => step(-1)}
                onNext={() => step(1)}
              />
            ) : null}
            {(mode === 'month-year' || mode === 'time') && (
              <DatePickerSelect
                format={mode === 'time' ? 'day-month-year' : 'month-year'}
                monthValue={MONTH_SHORT[month - 1]}
                yearValue={String(year)}
                dayValue="10"
              />
            )}
            {mode === 'month-year' && picker === 'month' && (
              <div className={styles.auxList} role="menu" aria-label="Months">
                {MONTHS.map((name) => (
                  <ListActionDropdownItem key={name} label={name} showIcon={false} />
                ))}
              </div>
            )}
            {mode === 'month-year' && picker === 'year' && (
              <div className={styles.auxList} role="menu" aria-label="Years">
                {[2024, 2025, 2026, 2027].map((value) => (
                  <ListActionDropdownItem key={value} label={String(value)} showIcon={false} />
                ))}
              </div>
            )}
            {mode !== 'time' && (
              <div className={styles.months}>
                <MonthGrid
                  year={year}
                  month={month}
                  selected={selected}
                  rangeStart={rangeStart}
                  rangeEnd={rangeEnd}
                  onSelect={selectDate}
                  labelledBy={mode === 'simple' ? titleId : undefined}
                />
                {dual && (
                  <>
                    <DividerVertical variant="middle-inset" />
                    <MonthGrid
                      year={nextMonth.year}
                      month={nextMonth.month}
                      selected={selected}
                      rangeStart={rangeStart}
                      rangeEnd={rangeEnd}
                      onSelect={selectDate}
                    />
                  </>
                )}
              </div>
            )}
            {mode === 'time' && (
              <div className={styles.timeRow}>
                <div className={styles.auxList} role="menu" aria-label="Hours">
                  {HOURS.map((hour) => (
                    <ListActionDropdownItem key={hour} label={hour} showIcon={false} />
                  ))}
                </div>
                <DividerVertical variant="middle-inset" />
                <div className={styles.auxList} role="menu" aria-label="Minutes">
                  {MINUTES.map((minute) => (
                    <ListActionDropdownItem key={minute} label={minute} showIcon={false} />
                  ))}
                </div>
              </div>
            )}
            <DividerHorizontal variant="full-width" />
            <div className={styles.actions}>
              <Button variant="text" size="sm" intent="primary" label="Limpar" onClick={onClear} />
              <div className={styles.actionPair}>
                <Button variant="text" size="sm" intent="secondary" label="Cancelar" onClick={onCancel} />
                <Button variant="solid" size="sm" intent="primary" label="Confirmar" onClick={onConfirm} />
              </div>
            </div>
          </div>
          {showPresets && (
            <>
              <DividerVertical variant="middle-inset" />
              <div className={styles.auxList} role="menu" aria-label="Presets">
                {PRESETS.map((preset) => (
                  <ListActionDropdownItem key={preset} label={preset} showIcon={false} />
                ))}
              </div>
            </>
          )}
        </>
      )}
    </div>
  );
}
