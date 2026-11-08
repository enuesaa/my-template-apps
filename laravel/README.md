# Laravel

## Project Creation Command
```bash
composer global require laravel/installer
composer global exec laravel new laravel-livewire-v4-memos
```

## Dev Commands
```bash
curl -H 'Accept: application/json' localhost/api/memos
curl -X POST -H 'Accept: application/json' --json '{"title":"hello","content":"world"}' localhost/api/memos
```
