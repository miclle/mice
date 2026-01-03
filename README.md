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
@import 'mice/scss/mice/variables';
@import 'mice/scss/mice/mixins';
@import 'mice/scss/mice/normalize';
@import 'mice/scss/mice/scaffolding';
@import 'mice/scss/mice/typography';

// Components
@import 'mice/scss/mice/buttons';
@import 'mice/scss/mice/grid';
@import 'mice/scss/mice/navbar';
@import 'mice/scss/mice/forms';
@import 'mice/scss/mice/tables';
@import 'mice/scss/mice/modals';
@import 'mice/scss/mice/alerts';
@import 'mice/scss/mice/panels';
@import 'mice/scss/mice/tabs';
@import 'mice/scss/mice/pagination';
@import 'mice/scss/mice/tooltips';
```

### With bundlers (Vite, Webpack, etc.)

```javascript
// Vite
import 'mice/css'

// Or with SCSS
@import 'mice/scss'
```

## Components

### CSS Components

- **Reset** - CSS normalize and reset
- **Typography** - Headings, paragraphs, lists, code
- **Grid** - Responsive grid system
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

# Start dev server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

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
