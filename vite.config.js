import { defineConfig } from 'vite'
import { resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import fs from 'node:fs'
import path from 'node:path'
import { exec } from 'node:child_process'
import { promisify } from 'node:util'

const execAsync = promisify(exec)

const __dirname = fileURLToPath(new URL('.', import.meta.url))

// Compile SCSS files to site/stylesheets
async function compileScss() {
  const miceScssFile = resolve(__dirname, 'scss/mice.scss')
  const miceCssFile = resolve(__dirname, 'site/stylesheets/mice.css')

  try {
    await execAsync(`npx sass ${miceScssFile} ${miceCssFile} --no-source-map`)
    console.log('✓ Compiled scss/mice.scss → site/stylesheets/mice.css')
  } catch (error) {
    console.error('Error compiling SCSS:', error)
  }
}

export default defineConfig(({ command }) => ({
  // Use docs directory for dev server only
  ...(command === 'serve' ? {
    root: 'site'
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
    server: {
      port: 5173,
      open: true,
      watch: {
        // Watch the scss directory for changes
        ignored: ['!**/scss/**']
      }
    },
    plugins: [
      {
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
      },
      {
        name: 'scss-watch-compile',
        configureServer() {
          compileScss()

          const scssDir = resolve(__dirname, 'scss')
          fs.watch(scssDir, { recursive: true }, (eventType, filename) => {
            if (filename && filename.endsWith('.scss')) {
              console.log(`\n🔄 SCSS changed: ${filename}`)
              compileScss()
            }
          })
        }
      }
    ]
  } : {})
}))
