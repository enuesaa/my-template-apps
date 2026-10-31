# my-svelte-template
A template repository for Svelte apps.

[![ci](https://github.com/enuesaa/my-svelte-template/actions/workflows/ci.yaml/badge.svg)](https://github.com/enuesaa/my-svelte-template/actions/workflows/ci.yaml)

## Stacks
- Svelte v5
- SvelteKit
- Vite
- Tailwind CSS
- Prettier
- @tanstack/svelte-query

## How to use
[degit](https://github.com/Rich-Harris/degit) is easy.

```bash
npx degit enuesaa/my-svelte-template
```

## Tailwind CSS V4 with PostCSS @apply directive
Add `@reference "./app.css";` to each `<style>` block.  
https://github.com/tailwindlabs/tailwindcss/discussions/13336

Subpath Import is also useful.  
https://tailwindcss.com/docs/functions-and-directives#subpath-imports
