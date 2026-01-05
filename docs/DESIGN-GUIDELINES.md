# Mice Framework - 语义化 HTML 设计规范 (Semantic HTML Design Principles)

## 核心设计原则 (Core Design Principle)

Mice 框架的设计初衷是充分利用 HTML 标签自身的语义性，避免过度使用 class 选择器。我们主张直接使用 HTML 标签来定义样式，而不是通过 `.class` 的方式。

### ✅ 推荐做法 (Recommended)

```scss
// 直接使用 HTML 标签定义样式
table {
  display: table;
  width: 100%;
  border-collapse: collapse;
}

ul,
ol {
  margin-bottom: $line-height-computed / 2;
  list-style-position: outside;
}

li {
  margin-bottom: 5px;
}

h1,
h2,
h3,
h4,
h5,
h6 {
  font-family: $heading-font-family;
  font-weight: $heading-font-weight;
  color: $heading-color;
}

code {
  font-family: $font-family-monospace;
  background-color: $code-background;
  padding: 2px 4px;
}

img {
  max-width: 100%;
  height: auto;
}
```

### ❌ 不推荐做法 (Not Recommended)

```scss
// 避免将 HTML 标签封装在 class 中
.table {
  /* 应该直接使用 table */
}
.list-item {
  /* 应该直接使用 li */
}
.heading {
  /* 应该直接使用 h1-h6 */
}
.code {
  /* 应该直接使用 code */
}
.image {
  /* 应该直接使用 img */
}
```

## 具体规范细则 (Specific Rules)

### 1. 列表元素 (List Elements)

```scss
// ✅ 正确
ul {
  list-style-type: disc;
  margin-left: 20px;
}

ol {
  list-style-type: decimal;
  margin-left: 20px;
}

li {
  margin-bottom: 5px;
}

// ❌ 错误
.un-list {
  /* 错误，应该使用 ul */
}
.or-list {
  /* 错误，应该使用 ol */
}
.list-item {
  /* 错误，应该使用 li */
}
```

### 2. 表格元素 (Table Elements)

```scss
// ✅ 正确
table {
  width: 100%;
  border-collapse: collapse;
}

thead {
  background-color: $table-head-background;
}

tbody {
  vertical-align: middle;
}

th {
  font-weight: bold;
  text-align: left;
}

td {
  padding: 8px;
}

// ❌ 错误
.table {
  /* 错误，应该使用 table */
}
.table-head {
  /* 错误，应该使用 thead */
}
.table-body {
  /* 错误，应该使用 tbody */
}
.table-row {
  /* 错误，应该使用 tr */
}
.table-cell {
  /* 错误，应该使用 th/td */
}
```

### 3. 表单元素 (Form Elements)

```scss
// ✅ 正确
fieldset {
  border: 1px solid $border-color;
  padding: 10px;
  margin-bottom: 10px;
}

input[type='text'],
input[type='email'],
input[type='password'] {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
}

textarea {
  resize: vertical;
  min-height: 100px;
}

select {
  padding: 8px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

// ❌ 错误
.fieldset {
  /* 错误，应该使用 fieldset */
}
.text-input {
  /* 错误，应该使用 input */
}
.text-area {
  /* 错误，应该使用 textarea */
}
.select-input {
  /* 错误，应该使用 select */
}
```

### 4. 语义化文本元素 (Semantic Text Elements)

```scss
// ✅ 正确
blockquote {
  border-left: 4px solid #ccc;
  padding-left: 16px;
  margin: 0 0 16px;
}

abbr[title] {
  border-bottom: 1px dotted;
  cursor: help;
}

address {
  font-style: italic;
}

code {
  background-color: #f4f4f4;
  padding: 2px 4px;
}

kbd {
  background-color: #f4f4f4;
  border: 1px solid #ccc;
  padding: 2px 4px;
}

pre {
  background-color: #f4f4f4;
  padding: 16px;
  overflow-x: auto;
}

// ❌ 错误
.blockquote {
  /* 错误，应该使用 blockquote */
}
.abbr {
  /* 错误，应该使用 abbr[title] */
}
.address {
  /* 错误，应该使用 address */
}
.code {
  /* 错误，应该使用 code */
}
.kbd {
  /* 错误，应该使用 kbd */
}
.pre {
  /* 错误，应该使用 pre */
}
```

### 5. 媒体元素 (Media Elements)

```scss
// ✅ 正确
img {
  max-width: 100%;
  height: auto;
  vertical-align: middle;
}

audio,
video {
  width: 100%;
  height: auto;
}

// ❌ 错误
.image {
  /* 错误，应该使用 img */
}
.audio {
  /* 错误，应该使用 audio */
}
.video {
  /* 错误，应该使用 video */
}
```

## 为什么这样做？ (Why This Approach?)

### 1. 语义化优势 (Semantic Benefits)

- HTML 标签本身具有明确的语义含义
- 减少 HTML 层级的复杂度
- 保持 HTML 结构简洁清晰
- 提升可访问性 (Accessibility)

### 2. 维护性优势 (Maintenance Benefits)

- 样式与 HTML 结构直接对应
- 减少类名的管理成本
- 避免类名冲突
- 更容易理解和使用

### 3. 性能优势 (Performance Benefits)

- 减少 CSS 文件大小
- 降低选择器匹配复杂度
- 提升 CSS 渲染性能

## SCSS 变量命名规范 (SCSS Variable Naming Convention)

虽然我们使用 HTML 标签直接定义样式，但 SCSS 变量仍然需要遵循命名规范：

```scss
// ✅ 正确
$table-background-color: #fff;
$table-border-color: #ddd;
$heading-font-family: 'Arial', sans-serif;
$code-background-color: #f4f4f4;

// ❌ 错误
$table-bg: #fff; // 应该使用完整的语义名称
$h-font: Arial; // 应该使用完整的语义名称
$code-bg: #f4f4f4; // 应该使用完整的语义名称
```

## 特殊情况处理 (Special Cases)

### 1. 使用 class 的唯一场景：改变标签语义

**唯一需要添加 class 的情况是：当需要改变 HTML 标签的默认语义，使其以其他形式呈现时。**

```scss
// ✅ 正确：将 a 标签展示成按钮样式
button,
.button {
  // ...
}

// 使用方式
<a class="button" href="#">我看起来像按钮</a>
```

**为什么需要这样做？**

- `a` 标签的默认语义是链接（可跳转）
- 添加 `.button` class 改变了其视觉呈现，使其看起来像按钮
- 但语义上仍然是链接（可访问性、SEO 仍然保持链接特性）

### 2. 其他允许使用 class 的情况

#### 2.1 需要重置默认样式时

```scss
// 重置表格默认样式
.reset-table {
  border-collapse: separate;
  border-spacing: 0;
}
```

#### 2.2 需要特殊变体样式时

```scss
// 表格的特殊样式变体 - 直接在 table 标签上使用变体
table.striped {
  tbody tr:nth-child(even) {
    background-color: #f9f9f9;
  }
}

table.hoverable {
  tbody tr:hover {
    background-color: #f5f5f5;
  }
}
```

```html
<!-- 使用方式 -->
<table class="striped">
  <!-- 表格内容 -->
</table>

<table class="hoverable">
  <!-- 表格内容 -->
</table>
```

#### 2.3 需要工具类时

```scss
// 布局工具类
.text-left {
  text-align: left;
}
.text-right {
  text-align: right;
}
.text-center {
  text-align: center;
}

.float-left {
  float: left;
}
.float-right {
  float: right;
}
.clearfix::after {
  content: '';
  display: table;
  clear: both;
}
```

### 3. 组件化设计（可选）

对于复杂的组件，可以考虑使用 BEM 命名规范：

```scss
// ✅ 正确
.block__element {
}
.block--modifier {
}

// 例如
.card {
}
.card__header {
}
.card__body {
}
.card--primary {
}
.card--secondary {
}
```

### 4. 不推荐的做法（避免）

```scss
// ❌ 错误：不改变语义，只是包装标签
.table {
  /* 应该直接使用 table */
}
.list-item {
  /* 应该直接使用 li */
}
.heading {
  /* 应该直接使用 h1-h6 */
}

// ❌ 错误：重复定义标签样式
div.box {
  /* 应该直接使用 .box 或者考虑使用语义标签 */
}
span.text {
  /* 应该直接使用 .text 或者考虑使用 p 标签 */
}
```

## 核心原则总结 (Core Principle Summary)

1. **默认使用 HTML 标签**：直接对 HTML 标签应用样式
2. **class 用于改变语义**：只有需要改变标签默认语义时才使用 class
3. **保持 HTML 简洁**：避免不必要的类名包装
4. **语义优先**：优先使用语义化 HTML 标签

## 总结 (Summary)

Mice 框架坚持使用 HTML 标签自身的语义性，通过直接对 HTML 标签应用样式来实现简洁、高效的 CSS 架构。这不仅符合 HTML 的设计初衷，也提升了代码的可维护性和性能。

记住：**让 HTML 做它应该做的事，让 CSS 做它应该做的事，各司其职，清晰明了。**
