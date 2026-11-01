<?php

use Livewire\Component;

new class extends Component
{
    public string $title = '';
};
?>

<div class="flex items-center justify-between">
    <h1 class="text-2xl sm:text-3xl font-bold">{{ $title }}</h1>

    {{ $slot }}
</div>
