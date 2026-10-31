import Link from 'next/link'
import { AiTwotoneSetting } from 'react-icons/ai'
import clsx from 'clsx'

const styles = {
  link: clsx('inline-block', 'p-3', 'rounded', 'hover:bg-grayer'),
}

export const HeaderSettingLink = () => {
  return (
    <Link href='/settings' className={styles.link}>
      <AiTwotoneSetting className='align-middle inline' />
    </Link>
  )
}
