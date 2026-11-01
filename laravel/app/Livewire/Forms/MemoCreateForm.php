<?php

namespace App\Livewire\Forms;

use Livewire\Attributes\Validate;
use Livewire\Form;

class MemoCreateForm extends Form
{
    #[Validate('required|max:100', message: 'Please provide a title')]
    public $title = '';

    #[Validate('required')]
    public $content = '';
}
