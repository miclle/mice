# Mice

Mice is a semantic CSS framework.

## Installation

### npm

```bash
npm install mice
```

### yarn

```bash
yarn add mice
```

### pnpm

```bash
pnpm add mice
```

## Usage

### Using compiled CSS

```css
@import 'mice/css';
```

Or link directly in HTML:

```html
<link rel="stylesheet" href="node_modules/mice/dist/mice.css">
```

### Using SCSS

```scss
@import 'mice/scss';
```

You can also import individual components:

```scss
// Core
@import 'mice/scss/variables';
@import 'mice/scss/mixins';
@import 'mice/scss/normalize';
@import 'mice/scss/scaffolding';
@import 'mice/scss/typography';

// Components
@import 'mice/scss/buttons';
@import 'mice/scss/grid';
@import 'mice/scss/navbar';
@import 'mice/scss/forms';
@import 'mice/scss/tables';
@import 'mice/scss/modals';
@import 'mice/scss/alerts';
@import 'mice/scss/panels';
@import 'mice/scss/tabs';
@import 'mice/scss/pagination';
@import 'mice/scss/tooltips';
```

### With bundlers (Vite, Webpack, etc.)

```javascript
// Vite
import 'mice/css'

// Or with SCSS
@import 'mice/scss'
```

## Documentation

- 📚 **Full Documentation**: [http://mice.miclle.com/](http://mice.miclle.com/) (Live examples and API reference)
- 🏠 **GitHub Pages**: [https://miclle.github.io/mice/](https://miclle.github.io/mice/) (Build artifacts)
- 📖 **Source Code**: [scss/](scss/) (SCSS source files)

## Components

### CSS Components

- **Reset** - CSS normalize and reset
- **Typography** - Headings, paragraphs, lists, code
- **Grid** - Responsive grid system (2-12 columns)
- **Buttons** - Various button styles and sizes
- **Forms** - Styled form elements
- **Tables** - Clean table styles
- **Navbar** - Navigation bar component
- **Sidebar** - Sidebar component
- **Modals** - Modal dialog styles
- **Alerts** - Alert and message styles
- **Panels** - Panel/card component
- **Tabs** - Tab navigation
- **Pagination** - Pagination component
- **Progress** - Progress bars
- **Tooltips** - Tooltip styles
- **Labels** - Label badges
- **Breadcrumbs** - Breadcrumb navigation
- **Lists** - Styled lists
- **Callouts** - Callout boxes
- **Timeline** - Timeline component
- **Media** - Media object

## Customization

### SCSS Variables

Override variables before importing:

```scss
$primary-color: #3498db;
$secondary-color: #2ecc71;
$font-size-base: 16px;

@import 'mice/scss';
```

### Available Variables

```scss
// Colors
$primary-color
$secondary-color
$success-color
$info-color
$warning-color
$danger-color

// Typography
$font-family-base
$font-size-base
$line-height-base

// Grid
$grid-columns
$grid-gutter-width

// And many more...
```

## Development

```bash
# Install dependencies
npm install

# Start dev server (serves docs directory)
npm run dev

# Build for production
npm run build

# Build and sync to docs directory
npm run build:sync

# Sync built CSS to docs (without rebuilding)
npm run sync

# Preview production build
npm run preview
```

### Development Workflow

When working on the CSS framework:

1. Modify SCSS files in `scss/`
2. Run `npm run build:sync` to build and sync changes to site
3. View changes at `http://localhost:5173`

## Class Naming Reference

Mice uses semantic class naming:

| Component | Class Name |
|-----------|------------|
| Buttons | `.button`, `.button primary`, `.button large` |
| Grid | `.grid`, `.grid two/three/four`, `.column` |
| Forms | `.field`, `form.inline` |
| Tables | `table.striped`, `table.bordered` |
| Panels | `.panel`, `.panel .body`, `.panel .heading` |
| Alerts | `.alert`, `.alert success` |
| Progress | `.progress`, `.progress .bar` |
| Tabs | `.tabs` |
| Navbar | `.navbar`, `.navbar .menu` |
| Labels | `.label`, `.label primary` |

## Browser Support

Modern browsers including Chrome, Firefox, Safari, and Edge.

## Contributing

1. Fork it (https://github.com/miclle/mice/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright and License

Code and documentation copyright 2014-2025 Miclle. Code released under the [MIT license](LICENSE).
