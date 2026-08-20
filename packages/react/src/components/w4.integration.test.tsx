import { describe, expect, it, afterEach } from 'vitest';
import { cleanup, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Accordion } from './Accordion/Accordion';
import { Avatar } from './Avatar/Avatar';
import { Carousel } from './Carousel/Carousel';
import { CarouselPaginationItem } from './CarouselPaginationItem/CarouselPaginationItem';
import { DividerHorizontal } from './DividerHorizontal/DividerHorizontal';
import { List } from './List/List';
import { ListActionDropdown } from './ListActionDropdown/ListActionDropdown';
import { Pagination } from './Pagination/Pagination';
import { PaginationItem } from './PaginationItem/PaginationItem';
import { Table } from './Table/Table';
import { TableExpandCell } from './TableExpandCell/TableExpandCell';
import { TableMobile } from './TableMobile/TableMobile';

afterEach(() => cleanup());

describe('DividerHorizontal', () => {
  it('renders subhead label', () => {
    render(<DividerHorizontal variant="with-subhead" label="Section" decorative={false} />);
    expect(screen.getByText('Section')).toBeInTheDocument();
    expect(screen.getByRole('separator')).toBeInTheDocument();
  });
});

describe('Avatar', () => {
  it('renders initials', () => {
    render(<Avatar content="initials" initials="AL" alt="Ana Lima" />);
    expect(screen.getByText('AL')).toBeInTheDocument();
  });
});

describe('Accordion', () => {
  it('toggles aria-expanded on the trigger', async () => {
    const user = userEvent.setup();
    render(<Accordion label="Details" />);
    const trigger = screen.getByRole('button', { name: /Details/ });
    expect(trigger).toHaveAttribute('aria-expanded', 'false');
    await user.click(trigger);
    expect(trigger).toHaveAttribute('aria-expanded', 'true');
    expect(screen.getByText('Panel content')).toBeVisible();
  });
});

describe('List', () => {
  it('uses menu role for dropdown and list for plain', () => {
    const { rerender } = render(<List type="dropdown" />);
    expect(screen.getByRole('menu')).toBeInTheDocument();
    rerender(<List type="plain" />);
    expect(screen.getByRole('list')).toBeInTheDocument();
  });
});

describe('ListActionDropdown', () => {
  it('exposes menuitem actions', () => {
    render(<ListActionDropdown />);
    expect(screen.getByRole('menu')).toBeInTheDocument();
    expect(screen.getByRole('menuitem', { name: 'Edit' })).toBeInTheDocument();
  });
});

describe('Table', () => {
  it('renders a semantic table with column headers', () => {
    render(<Table columns="3" />);
    expect(screen.getByRole('table')).toBeInTheDocument();
    expect(screen.getAllByRole('columnheader').length).toBeGreaterThan(0);
  });
});

describe('TableExpandCell', () => {
  it('names expand control and reflects aria-expanded', () => {
    render(
      <table>
        <tbody>
          <tr>
            <TableExpandCell type="body" expanded={false} />
          </tr>
        </tbody>
      </table>,
    );
    expect(screen.getByRole('button', { name: 'Expand' })).toHaveAttribute('aria-expanded', 'false');
  });
});

describe('TableMobile', () => {
  it('maps interactive to a button', () => {
    render(<TableMobile interactive title="Offer 01" />);
    expect(screen.getByRole('button', { name: /Offer 01/ })).toBeInTheDocument();
  });
});

describe('Pagination', () => {
  it('exposes a pagination landmark and current page', () => {
    render(<Pagination position="start" />);
    expect(screen.getByRole('navigation', { name: 'Pagination' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Page 1' })).toHaveAttribute('aria-current', 'page');
    expect(screen.getByRole('button', { name: 'Previous page' })).toBeDisabled();
  });
});

describe('PaginationItem', () => {
  it('keeps overflow decorative', () => {
    render(<PaginationItem content="overflow" />);
    expect(screen.queryByRole('button')).not.toBeInTheDocument();
  });
});

describe('Carousel', () => {
  it('exposes carousel semantics without focusable dots', () => {
    render(<Carousel itemCount="3" itemView="2" aria-label="Photos" />);
    expect(screen.getByLabelText('Photos')).toHaveAttribute('aria-roledescription', 'carousel');
    expect(screen.queryByRole('button')).not.toBeInTheDocument();
    expect(screen.queryByRole('tab')).not.toBeInTheDocument();
  });
});

describe('CarouselPaginationItem', () => {
  it('keeps dots decorative', () => {
    render(<CarouselPaginationItem itemCount="3" itemView="2" />);
    expect(screen.queryByRole('button')).not.toBeInTheDocument();
  });
});
