<script lang="ts">
	import { ArrowBigRightDash } from 'lucide-svelte'

	let { id }: { id: number } = $props()
</script>

<a href={`/posts/${id}/edit`}>
	<ArrowBigRightDash class="inline w-4" />
	<span>Edit</span>
</a>

<style lang="postcss">
	@reference "#app.css";

	a {
		@apply font-zenkaku block w-fit mx-3 my-3;
	}
	span {
		@apply inline-block border-b-2 border-dotted;
		@apply hover:border-dashed;
	}
</style>
