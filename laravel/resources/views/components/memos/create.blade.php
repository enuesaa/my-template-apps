<?php

use App\Models\Memo;
use Livewire\Attributes\On;
use Livewire\Component;
use Livewire\Attributes\Validate;

new class extends Component
{
    public $show = false;

    #[Validate('required|max:100', message: 'Please provide a title')]
    public $title = '';
 
    #[Validate('required')]
    public $content = '';
 
    public function save()
    {
        Memo::create($this->validate());

        return redirect()->to('/');
    }

    #[On('createMemoModal.close')] 
    public function close(): void
    {
        $this->show = false;
    }

    #[On('createMemoModal.open')] 
    public function open(): void
    {
        $this->show = true;
    }
};
?>

<livewire:modal title="New Memo" wire:model="show" dispatchOnClose="createMemoModal.close">
    <form wire:submit="save" class="space-y-3">
        <label>
            Title
            <input type="text" wire:model="title" class="mt-1 block w-full rounded-md border px-3 py-2 text-sm">
            @error('title') <p class="text-xs text-red-600 mt-1">{{ $message }}</p> @enderror
        </label>
        <label>
            Content
            <textarea wire:model="content" rows="5" class="mt-1 block w-full rounded-md border px-3 py-2 text-sm"></textarea>
            @error('content') <p class="text-xs text-red-600 mt-1">{{ $message }}</p> @enderror
        </label>
        <div class="flex justify-end gap-2">
            <button type="button" wire:click="close" class="inline-flex items-center gap-2 px-3 py-1.5 rounded-md text-sm bg-transparent text-slate-700 hover:bg-slate-50">Cancel</button>
            <livewire:button type="submit" label="Save" />
        </div>
    </form>
</livewire:modal>
