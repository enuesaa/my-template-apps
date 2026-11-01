<?php

use Livewire\Attributes\Modelable;
use Livewire\Component;

new class extends Component
{
    #[Modelable]
    public bool $show = false;
    public string $title = '';
    public string $dispatchOnClose;
};
?>

<div>

@if ($show == true)
    <div class="fixed inset-0 z-50 flex items-center justify-center">
        <div class="absolute inset-0 bg-black/40" wire:click="$dispatch('{{ $dispatchOnClose }}')"></div>
        <div class="relative w-full max-w-lg mx-4 bg-white rounded-lg shadow-lg border border-slate-100 p-4">
            <div class="flex items-center justify-between mb-3">
                <h3 class="text-lg font-semibold">{{ $title }}</h3>
                <button wire:click="$dispatch('{{ $dispatchOnClose }}')" class="bg-white">✕</button>
            </div>

            {{ $slot }}
        </div>
    </div>
@endif

</div>
