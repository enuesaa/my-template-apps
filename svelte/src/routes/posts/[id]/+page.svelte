<script lang="ts">
	import PageTitle from '$lib/components/PageTitle.svelte'
	import EditLink from './EditLink.svelte'
	import { getPost } from '$lib/api/posts'

	let { data } = $props()
	let post = $derived(getPost(data.id))
</script>

<PageTitle title="Detail" />

{#if post.data !== undefined}
	<div class="text-lg px-3 bg-grayer py-5">
		{post.data.title}
	</div>
	<EditLink id={data.id} />
{/if}
