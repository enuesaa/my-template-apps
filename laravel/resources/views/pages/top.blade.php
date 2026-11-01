<?php

use App\Models\Memo;
use Livewire\Component;
use Livewire\Attributes\Computed;
use Livewire\Attributes\Title;

new #[Title('top')] class extends Component
{
    #[Computed]
    public function memos()
    {
        return Memo::all();
    }
};
?>

<div>
    <livewire:pagetop title="Top">
        <livewire:button label="New Post" dispatchOnClick="createMemoModal.open" />
    </livewire:pagetop>

    <ul class="mt-6 space-y-3">
    @foreach ($this->memos as $memo)
        <li>
            <a href="/memos/{{ $memo->id }}" class="block bg-white rounded-lg border border-slate-100 p-4 hover:shadow-sm">
                <h3 class="font-medium text-slate-900">{{ $memo->title }}</h3>
                <p class="mt-1 text-sm text-slate-600 truncate">{{ $memo->content }}</p>
            </a>
        </li>
    @endforeach
    </ul>

    <livewire:memos.create />
</div>
