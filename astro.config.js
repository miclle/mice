import { defineConfig } from 'astro/config';
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import fs from 'node:fs';
import { exec } from 'node:child_process';
import { promisify } from 'node:util';

const execAsync = promisify(exec);
const __dirname = fileURLToPath(new URL('.', import.meta.url));

// Compile SCSS files to site/public/stylesheets
async function compileScss() {
  const miceScssFile = resolve(__dirname, 'scss/mice.scss');
  const miceCssFile = resolve(__dirname, 'site/public/stylesheets/mice.css');
  const docScssFile = resolve(__dirname, 'site/public/stylesheets/doc.scss');
  const docCssFile = resolve(__dirname, 'site/public/stylesheets/doc.css');

  try {
    await execAsync(`npx sass ${miceScssFile} ${miceCssFile} --no-source-map`);
    console.log('✓ Compiled scss/mice.scss → site/public/stylesheets/mice.css');

    await execAsync(`npx sass ${docScssFile} ${docCssFile} --no-source-map`);
    console.log('✓ Compiled site/public/stylesheets/doc.scss → site/public/stylesheets/doc.css');
  } catch (error) {
    console.error('Error compiling SCSS:', error);
  }
}

export default defineConfig({
  srcDir: './site/src',
  outDir: './site/static',
  publicDir: './site/public',
  build: {
    format: 'directory',
  },
  vite: {
    plugins: [
      {
        name: 'scss-watch-compile',
        configureServer() {
          compileScss();

          // Watch both scss and site/public/stylesheets directories
          const scssDir = resolve(__dirname, 'scss');
          const siteScssDir = resolve(__dirname, 'site/public/stylesheets');

          const watchHandler = (eventType, filename) => {
            if (filename && filename.endsWith('.scss')) {
              console.log(`\n🔄 SCSS changed: ${filename}`);
              compileScss();
            }
          };

          fs.watch(scssDir, { recursive: true }, watchHandler);
          fs.watch(siteScssDir, { recursive: false }, watchHandler);
        },
      },
    ],
  },
});
