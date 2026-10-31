<script lang="ts">
	import { page } from '$app/state'
</script>

<svelte:head>
	<title>my-svelte-template</title>
</svelte:head>

<h3 class="text-4xl font-bold m-1 mt-10 text-center w-full">
	{#if page?.error?.message === undefined}
		404 Not Found
	{:else}
		{page.error.message}
	{/if}
</h3>
