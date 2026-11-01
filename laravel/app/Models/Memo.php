<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Memo extends Model
{
    /**
     * @var list<string>
     */
    protected $fillable = [
        'title',
        'content',
    ];
}
