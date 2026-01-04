import { defineConfig } from 'vite'
import { resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import fs from 'node:fs'
import path from 'node:path'

const __dirname = fileURLToPath(new URL('.', import.meta.url))

export default defineConfig(({ command }) => ({
  // Use docs directory for dev server only
  ...(command === 'serve' ? {
    root: 'site',
    server: {
      port: 5173,
      open: true
    }
  } : {}),

  // Build configuration
  build: {
    outDir: 'dist',
    emptyOutDir: true,
    lib: {
      entry: resolve(__dirname, 'scss/mice.scss'),
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
    sourcemap: true
  },
  css: {
    preprocessorOptions: {
      scss: {
        api: 'modern-compiler',
        silenceDeprecations: ['legacy-js-api', 'import', 'color-functions', 'global-builtin', 'slash-div', 'if-function']
      }
    }
  },

  // For dev server, add a plugin to handle directory routes
  ...(command === 'serve' ? {
    plugins: [{
      name: 'directory-index-fallback',
      configureServer(server) {
        server.middlewares.use((req, res, next) => {
          // If the URL doesn't have an extension
          if (!req.url.includes('.')) {
            // Use server.config.root which is the 'docs' directory
            const requestedPath = path.join(server.config.root, req.url.split('?')[0])
            const indexPath = path.join(requestedPath, 'index.html')

            // If it's a directory with index.html, rewrite the URL
            if (fs.existsSync(requestedPath) && fs.statSync(requestedPath).isDirectory() && fs.existsSync(indexPath)) {
              req.url = path.join(req.url, 'index.html').replace(/\\/g, '/')
            }
          }
          next()
        })
      }
    }]
  } : {})
}))
