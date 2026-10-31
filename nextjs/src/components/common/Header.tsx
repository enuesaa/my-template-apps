import { HeaderTitleLink } from './HeaderTitleLink'
import { HeaderSettingLink } from './HeaderSettingLink'

export const Header = () => {
  return (
    <header className='w-full'>
      <div className='container mx-auto flex text-2xl font-semibold'>
        <div className='flex-auto'>
          <HeaderTitleLink />
        </div>

        <div className='w-24'>
          <HeaderSettingLink />
        </div>
      </div>
    </header>
  )
}
