# Semantic Element

Semantic Element is a semantic CSS framework that styles native HTML elements.

## Installation

### npm

```bash
npm install semantic-element
```

### yarn

```bash
yarn add semantic-element
```

### pnpm

```bash
pnpm add semantic-element
```

## Usage

### Using compiled CSS

```css
@import 'semantic-element/css';
```

Or link directly in HTML:

```html
<link rel="stylesheet" href="node_modules/semantic-element/dist/semantic-element.css" />
```

### Using SCSS

```scss
@import 'semantic-element/scss';
```

You can also import individual components:

```scss
// Core
@import 'semantic-element/scss/variables';
@import 'semantic-element/scss/mixins';
@import 'semantic-element/scss/normalize';
@import 'semantic-element/scss/scaffolding';
@import 'semantic-element/scss/typography';

// Components
@import 'semantic-element/scss/buttons';
@import 'semantic-element/scss/grid';
@import 'semantic-element/scss/navbar';
@import 'semantic-element/scss/forms';
@import 'semantic-element/scss/tables';
@import 'semantic-element/scss/dialog';
@import 'semantic-element/scss/alerts';
@import 'semantic-element/scss/panels';
@import 'semantic-element/scss/tabs';
@import 'semantic-element/scss/pagination';
@import 'semantic-element/scss/tooltips';
```

### With bundlers (Vite, Webpack, etc.)

```javascript
// Vite
import 'semantic-element/css'

// Or with SCSS
@import 'semantic-element/scss'
```

## Documentation

- 📚 **Full Documentation**: [https://semantic-element.com](https://semantic-element.com) (Live examples and API reference)
- 📖 **Source Code**: [scss/](scss/) (SCSS source files)
- 🐛 **Issues**: [https://github.com/miclle/semantic-element/issues](https://github.com/miclle/semantic-element/issues)

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
- **Dialog** - Dialog component using native HTML dialog element
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

@import 'semantic-element/scss';
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

# Start dev server
npm run dev

# Build for production
npm run build

# Build documentation site
npm run build:site

# Preview production build
npm run preview:site
```

### Development Workflow

When working on the CSS framework:

1. Modify SCSS files in `scss/`
2. Run `npm run build` to build changes
3. View changes at `http://localhost:4321`

## Class Naming Reference

Semantic Element uses semantic class naming:

| Component | Class Name                                    |
| --------- | --------------------------------------------- |
| Buttons   | `.button`, `.button primary`, `.button large` |
| Grid      | `.grid`, `.grid two/three/four`, `.column`    |
| Forms     | `.field`, `form.inline`                       |
| Tables    | `table.striped`, `table.bordered`             |
| Panels    | `.panel`, `.panel .body`, `.panel .heading`   |
| Alerts    | `.alert`, `.alert success`                    |
| Progress  | `.progress`, `.progress .bar`                 |
| Tabs      | `.tabs`                                       |
| Navbar    | `.navbar`, `.navbar .menu`                    |
| Labels    | `.label`, `.label primary`                    |

## Browser Support

Modern browsers including Chrome, Firefox, Safari, and Edge.

## Contributing

1. Fork it (https://github.com/miclle/semantic-element/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright and License

Code and documentation copyright 2014-2025 Miclle. Code released under the [MIT license](LICENSE).
