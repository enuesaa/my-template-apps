import { queryGet, mutatePut } from './common'

type Post = {
	id: number
	title: string
}
export const listPosts = () => queryGet<Post[]>(`/posts`)
export const getPost = (id: number) => queryGet<Post>(`/posts/${id}`)

type CreatePostRequest = {
	title: string
}
export const createPost = () => mutatePut<CreatePostRequest, {}>(`/posts`)

type UpdatePostRequest = {
	id: number
	title: string
}
export const updatePost = (id: number) => mutatePut<UpdatePostRequest, {}>(`/posts/${id}`)
