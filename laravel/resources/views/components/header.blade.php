<?php

use Livewire\Component;

new class extends Component
{
};
?>

<header class="bg-white border-b border-slate-200">
    <div class="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between gap-4">
        <a href="/" class="inline-flex items-center gap-3">
            <span class="inline-flex items-center justify-center w-9 h-9 rounded-md bg-sky-600 text-white font-semibold"></span>
            <span class="text-lg font-semibold text-slate-900 hidden sm:inline">Memos</span>
        </a>

        <nav class="flex items-center gap-3 text-sm">
            <a href="/about" class="text-slate-600 hover:text-slate-900">About</a>
        </nav>
    </div>
</header>
