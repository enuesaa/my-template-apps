<?php

namespace App\Http\Livewire\Memos;

use Livewire\Component;
use App\Models\Memo;

class Create extends Component
{
    public $show = false;
    public $title = '';
    public $content = '';

    protected $listeners = [
        'openCreateModal' => 'open',
        'closeCreateModal' => 'close',
    ];

    protected function rules(): array
    {
        return [
            'title' => 'required|max:100',
            'content' => 'required',
        ];
    }

    public function open()
    {
        $this->show = true;
    }

    public function close()
    {
        $this->resetForm();
        $this->show = false;
    }

    public function save()
    {
        $this->validate();

        Memo::create([
            'title' => $this->title,
            'content' => $this->content,
        ]);

        // Notify parent or other components
        $this->emitUp('memoCreated');

        $this->close();
    }

    public function resetForm()
    {
        $this->title = '';
        $this->content = '';
    }

    public function render()
    {
        return view('livewire.memos.create');
    }
}
