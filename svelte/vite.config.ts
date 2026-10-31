import { defineConfig } from 'vite'
import { sveltekit } from '@sveltejs/kit/vite'
import tailwindcss from '@tailwindcss/vite'
import path from 'node:path'

export default defineConfig({
	plugins: [
		sveltekit(),
		tailwindcss(),
	],
	resolve: {
		alias: {
			$lib: path.join(__dirname, './src/lib'),
		},
	}
})
