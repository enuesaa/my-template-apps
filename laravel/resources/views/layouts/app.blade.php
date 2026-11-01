<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- styles -->
        <script src="https://cdn.jsdelivr.net/npm/@unocss/runtime/uno.global.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@unocss/reset/tailwind-compat.min.css" />
        <style>
            /* https://unocss.dev/integrations/runtime#preventing-fouc */
            [un-cloak] {
                display: none;
            }
        </style>
        <title>{{ $title ?? 'Page Title' }}</title>
    </head>

    <body class="min-h-screen bg-slate-50 text-slate-900 antialiased" un-cloak>
        <livewire:header />

        <main class="max-w-4xl mx-auto p-4 min-h-dvh">
            <div class="space-y-6">
                {{ $slot }}
            </div>
        </main>

        <livewire:footer />
    </body>
</html>
