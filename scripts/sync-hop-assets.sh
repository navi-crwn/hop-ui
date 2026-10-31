#!/usr/bin/env bash
# Refresh the bundled fallback from an unpublished HEL.ink checkout or the hub.
set -euo pipefail
cd "$(dirname "$0")/.."
target=resources/hop-assets/apps.json
if [[ -n "${1:-}" ]]; then
  cp "$1/public/hop-assets/apps.json" "$target.new"
else
  curl -fsS https://hel.ink/hop-assets/apps.json -o "$target.new"
fi
python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$target.new"
mv "$target.new" "$target"
