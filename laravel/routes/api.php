<?php

use App\Http\Controllers\Api\MemoController;
use Illuminate\Support\Facades\Route;

Route::get('/memos', [MemoController::class, 'index']);
Route::post('/memos', [MemoController::class, 'store']);
Route::get('/memos/{memo}', [MemoController::class, 'show']);
Route::put('/memos/{memo}', [MemoController::class, 'update']);
Route::delete('/memos/{memo}', [MemoController::class, 'destroy']);
