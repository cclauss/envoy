#!/bin/bash

set -e

CONFIGGEN="$1"
shift
OUT_DIR="$1"
shift

mkdir -p "$OUT_DIR/certs"
"$CONFIGGEN" "$OUT_DIR"

for FILE in $*; do
  case "$FILE" in
  *.pem)
    cp "$FILE" "$OUT_DIR/certs"
    ;;
  *)

    FILENAME="$(echo $FILE | sed -e 's/.*examples\///g')"
    # Configuration filenames may conflict. To avoid this we use the full path.
    cp -v "$FILE" "$OUT_DIR/${FILENAME//\//_}"
    ;;
  esac
done

# tar is having issues with -C for some reason so just cd into OUT_DIR.
(cd "$OUT_DIR"; tar -hcvf example_configs.tar *.yaml certs/*.pem)
