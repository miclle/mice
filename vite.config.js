import { defineConfig } from 'vite'

export default defineConfig({
  build: {
    // Only build CSS library
    lib: {
      entry: './src/styles/mice.scss',
      name: 'Mice',
      fileName: 'mice',
      formats: ['es']
    },
    rollupOptions: {
      output: {
        assetFileNames: 'mice.[ext]'
      }
    },
    cssCodeSplit: false,
    minify: 'esbuild',
    sourcemap: true,
    // Don't delete index.html during build
    emptyOutDir: false
  },
  css: {
    preprocessorOptions: {
      scss: {
        api: 'modern-compiler',
        silenceDeprecations: ['legacy-js-api', 'import', 'color-functions', 'global-builtin', 'slash-div', 'if-function']
      }
    }
  }
})
