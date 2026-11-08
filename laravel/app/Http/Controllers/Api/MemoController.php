<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreMemoRequest;
use App\Models\Memo;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;

class MemoController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(Memo::latest()->get());
    }

    public function store(StoreMemoRequest $request): JsonResponse
    {
        $memo = Memo::create($request->validated());

        return response()->json($memo, 201);
    }

    public function show(Memo $memo): JsonResponse
    {
        return response()->json($memo);
    }

    public function update(StoreMemoRequest $request, Memo $memo): JsonResponse
    {
        $memo->update($request->validated());

        return response()->json($memo);
    }

    public function destroy(Memo $memo): Response
    {
        $memo->delete();

        return response()->noContent();
    }
}
