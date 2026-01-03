#!/usr/bin/env node

/**
 * Sync built CSS to docs directory
 * This script copies the built CSS to the docs directory for preview
 */

import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'node:url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))
const rootDir = path.resolve(__dirname, '..')
const distDir = path.join(rootDir, 'dist')
const docsStylesDir = path.join(rootDir, 'docs/stylesheets')

console.log('Syncing CSS to docs directory...')

// Ensure dist directory exists
if (!fs.existsSync(distDir)) {
  console.error('Dist directory not found. Run `npm run build` first.')
  process.exit(1)
}

// Ensure docs stylesheets directory exists
if (!fs.existsSync(docsStylesDir)) {
  fs.mkdirSync(docsStylesDir, { recursive: true })
}

// Copy mice.css to docs
const sourceCss = path.join(distDir, 'mice.css')
const targetCss = path.join(docsStylesDir, 'mice.css')

if (fs.existsSync(sourceCss)) {
  fs.copyFileSync(sourceCss, targetCss)
  console.log('✓ Copied mice.css to docs/stylesheets/')
} else {
  console.error('Source CSS not found:', sourceCss)
  process.exit(1)
}

// Also copy sourcemap if exists
const sourceMap = path.join(distDir, 'mice.css.map')
const targetMap = path.join(docsStylesDir, 'mice.css.map')

if (fs.existsSync(sourceMap)) {
  fs.copyFileSync(sourceMap, targetMap)
  console.log('✓ Copied mice.css.map to docs/stylesheets/')
}

console.log('\nDone! Now the docs directory will use the latest built CSS.')
