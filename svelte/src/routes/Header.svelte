<script lang="ts">
	import { Cloudy } from 'lucide-svelte'
</script>

<header>
	<a href="/" class="inline-block">
		<h1>
			my-svelte-template <Cloudy class="inline" />
		</h1>
	</a>
</header>

<style lang="postcss">
	@reference "#app.css";

	header {
		@apply container mx-auto pt-2 pb-4 mb-4;
	}
	h1 {
		@apply font-zenkaku text-2xl font-bold px-2;
	}
</style>
