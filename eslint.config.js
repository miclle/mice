import js from '@eslint/js'

export default [
  js.configs.recommended,
  {
    ignores: ['dist/**/*', 'site/**/*'],
    languageOptions: {
      globals: {
        URL: 'readonly',
        console: 'readonly'
      }
    }
  }
]