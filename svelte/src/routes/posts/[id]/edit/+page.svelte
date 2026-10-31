<script lang="ts">
	import PageTitle from '$lib/components/PageTitle.svelte'
	import { getPost, updatePost } from '$lib/api/posts'
	import { goto } from '$app/navigation'

	let { data } = $props()
	let post = $derived(getPost(data.id))
	let update = $derived(updatePost(data.id))

	async function handleUpdate(e: MouseEvent) {
		e.preventDefault()
		if (post.data === undefined) {
			return
		}
		await update.mutateAsync({
			id: post.data.id,
			title: post.data.title,
		})
		await goto(`/posts/${data.id}`)
	}
</script>

<PageTitle title="Edit" />

{#if post.data !== undefined}
	<textarea bind:value={post.data.title} class="w-full text-lg px-3 bg-grayer py-5 outline-none"></textarea>
	<button onclick={handleUpdate}>save</button>
{/if}

<style lang="postcss">
	@reference "#app.css";

	button {
		@apply inline-block border-b-2 border-dotted cursor-pointer;
		@apply hover:border-dashed;
	}
</style>
