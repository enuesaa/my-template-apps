<?php
 
use App\Models\Memo;
use Livewire\Attributes\On;
use Livewire\Attributes\Title;
use Livewire\Component;
 
new #[Title('memo')] class extends Component
{
    public Memo $post;
 
    public function mount($id) 
    {
        $this->post = Memo::findOrFail($id);
    }

    #[On('memos.{post.id}.delete')] 
    public function delete()
    {
        $this->post->deleteOrFail();

        return redirect()->to('/');
    }
};
?>

<div>
    <livewire:pagetop title="{{ $this->post->title }}">
        <livewire:button label="delete" dispatchOnClick="memos.{{ $post->id }}.delete" />
    </livewire:pagetop>

    <div class="text-sm text-slate-500 mb-3">
        Created {{ $this->post->created_at->diffForHumans() }}
    </div>

    <div class="bg-white rounded-lg border border-slate-100 p-6 prose prose-slate max-w-none">
        {{ $this->post->content }}
    </div>
</div>
