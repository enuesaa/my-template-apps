// interface Env {}

export default {
  async fetch(request: Request, env: Env) {
		return new Response('hello')
	},
}
