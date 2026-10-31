import { ReactNode } from 'react'

type Props = {
  children: ReactNode
}
export const Main = ({ children }: Props) => {
  return <main className='w-full mx-auto container py-5'>{children}</main>
}
