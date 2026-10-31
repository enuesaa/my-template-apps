import type { Metadata } from 'next'
import { ReactNode } from 'react'
import { Providers } from './providers'
import './globals.css'

export const metadata: Metadata = {
  title: 'my-nextjs-template',
}

type Props = {
  children: ReactNode
}

export default function RootLayout({ children }: Props) {
  return (
    <html lang='ja'>
      <body className='text-blac bg-gray-300 font-zenkaku'>
        <Providers>{children}</Providers>
      </body>
    </html>
  )
}
