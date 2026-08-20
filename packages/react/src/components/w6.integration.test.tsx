import { describe, expect, it, vi, afterEach } from 'vitest';
import { cleanup, render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Calendar } from './Calendar/Calendar';
import { FileUploader } from './FileUploader/FileUploader';
import { FileUploaderDropzoneItem } from './FileUploaderDropzoneItem/FileUploaderDropzoneItem';
import { FileUploaderItem } from './FileUploaderItem/FileUploaderItem';
import { Keyboard } from './Keyboard/Keyboard';
import { SearchViewFullscreen } from './SearchViewFullscreen/SearchViewFullscreen';
import { Slider } from './Slider/Slider';
import { StepProgressIndicator } from './StepProgressIndicator/StepProgressIndicator';
import { StepperPrimary } from './StepperPrimary/StepperPrimary';
import { VerticalStepper } from './VerticalStepper/VerticalStepper';

afterEach(() => cleanup());

describe('FileUploader', () => {
  it('opens the file picker from the upload action', async () => {
    const user = userEvent.setup();
    const onChange = vi.fn();
    render(<FileUploader label="Documentos" onChange={onChange} showFiles={false} />);
    expect(screen.getByText('Documentos')).toBeInTheDocument();
    await user.click(screen.getByRole('button', { name: 'Selecionar arquivo' }));
  });

  it('renders skeleton bones without nested actions', () => {
    render(<FileUploader state="skeleton" label="Documentos" />);
    expect(screen.queryByRole('button', { name: 'Selecionar arquivo' })).not.toBeInTheDocument();
  });
});

describe('FileUploaderDropzoneItem', () => {
  it('names the dropzone from helper text', () => {
    render(<FileUploaderDropzoneItem helperText="Solte o arquivo aqui" />);
    expect(screen.getByRole('button', { name: 'Solte o arquivo aqui' })).toBeInTheDocument();
  });
});

describe('FileUploaderItem', () => {
  it('announces validation on danger-short', () => {
    render(<FileUploaderItem state="danger-short" fileName="cnh.pdf" shortDescription="Arquivo inválido" />);
    expect(screen.getByRole('alert')).toHaveTextContent('Arquivo inválido');
  });
});

describe('Calendar', () => {
  it('selects a day in the grid', async () => {
    const user = userEvent.setup();
    const onSelect = vi.fn();
    render(<Calendar mode="simple" selected="2025-09-10" onSelect={onSelect} />);
    await user.click(screen.getByRole('gridcell', { name: '2025-09-17' }));
    expect(onSelect).toHaveBeenCalledWith('2025-09-17');
  });
});

describe('Slider', () => {
  it('updates from the range input', async () => {
    const user = userEvent.setup();
    const onValueChange = vi.fn();
    render(<Slider label="Limite" defaultValue={40} onValueChange={onValueChange} />);
    const slider = screen.getByRole('slider');
    await user.click(slider);
    expect(slider).toHaveAttribute('aria-labelledby');
  });
});

describe('StepperPrimary', () => {
  it('exposes the step label', () => {
    render(<StepperPrimary status="current" label="Endereço" />);
    expect(screen.getByText('Endereço')).toBeInTheDocument();
  });
});

describe('VerticalStepper', () => {
  it('marks the current step', () => {
    render(<VerticalStepper />);
    expect(screen.getByText('Endereço').closest('li')).toHaveAttribute('aria-current', 'step');
  });
});

describe('StepProgressIndicator', () => {
  it('names the current step without a progressbar role', () => {
    render(<StepProgressIndicator stepCount="4" currentStep="2" />);
    expect(screen.getByText('Etapa 2 de 4')).toBeInTheDocument();
    expect(screen.queryByRole('progressbar')).not.toBeInTheDocument();
  });
});

describe('SearchViewFullscreen', () => {
  it('clears from the named control', async () => {
    const user = userEvent.setup();
    const onClear = vi.fn();
    render(<SearchViewFullscreen content="value" query="Ana" showResults={false} onClear={onClear} />);
    await user.click(screen.getByRole('button', { name: 'Clear' }));
    expect(onClear).toHaveBeenCalled();
  });
});

describe('Keyboard', () => {
  it('stays decorative', () => {
    render(<Keyboard configuration="numeric-only" />);
    expect(screen.queryByRole('button')).not.toBeInTheDocument();
  });
});
