#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOUNDS_DIR="$ROOT_DIR/assets/sounds"

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is not installed or not on PATH." >&2
  exit 1
fi

if [ ! -d "$SOUNDS_DIR" ]; then
  echo "Sounds directory not found: $SOUNDS_DIR" >&2
  exit 1
fi

shopt -s nullglob
for in_file in "$SOUNDS_DIR"/*.mp3 "$SOUNDS_DIR"/*.wav "$SOUNDS_DIR"/*.ogg; do
  [ -e "$in_file" ] || continue
  ext="${in_file##*.}"
  base="$(basename "$in_file" ".$ext")"
  tmp="${SOUNDS_DIR}/${base}.normalized.mp3"

  echo "Normalizing $in_file -> $tmp"
  ffmpeg -y -i "$in_file" -acodec libmp3lame -ac 2 -ar 44100 -b:a 192k "$tmp" >/dev/null 2>&1

  mv "$tmp" "$in_file"
done

echo "Audio normalization complete."

