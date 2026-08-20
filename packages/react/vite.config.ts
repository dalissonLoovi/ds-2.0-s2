import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'node:path';

export default defineConfig({
  plugins: [react()],
  build: {
    lib: {
      entry: {
        index: path.resolve(__dirname, 'src/index.ts'),
        draft: path.resolve(__dirname, 'src/draft.ts'),
      },
      formats: ['es'],
      fileName: (_format, entryName) => `${entryName}.js`,
    },
    rollupOptions: {
      external: ['react', 'react-dom', 'react/jsx-runtime', '@tabler/icons-react'],
      output: {
        assetFileNames: 'styles.css',
      },
    },
    cssCodeSplit: false,
    sourcemap: true,
  },
});
