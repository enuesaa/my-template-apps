<script lang="ts">
	import PageTitle from '$lib/components/PageTitle.svelte'
	import { listPosts } from '$lib/api/posts'

	const posts = listPosts()
</script>

<PageTitle title="Top Page" />

{#if posts.data}
	<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 p-0 m-0 list-none">
		{#each posts.data as post}
			<a
				href={`/posts/${post.id}`}
				class="bg-grayer border-grayer rounded-xl p-4 border shadow-sm h-full transition-transform duration-150 hover:-translate-y-1 hover:shadow-lg"
			>
				{post.title}
			</a>
		{/each}
	</div>
{/if}
