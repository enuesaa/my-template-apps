import Link from 'next/link'
import { FaGuitar } from 'react-icons/fa'

export const HeaderTitleLink = () => {
  return (
    <Link href='/' className='inline-block p-3 rounded hover:bg-grayer'>
      <FaGuitar className='align-middle mr-1 inline' /> my-nextjs-template
    </Link>
  )
}
