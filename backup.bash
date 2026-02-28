#!/bin/bash
rsync --dry-run \
  --itemize-changes \
  --exclude "/mnt/d/\$RECYCLE.BIN" \
  --exclude "/mnt/d/System Volume Information" \
  --exclude "/mnt/d/rsync.log" \
  --recursive "/mnt/d/" "/mnt/e/" \
  >> "/mnt/d/rsync.log"

rsync \
  --dry-run \
  --itemize-changes \
  "/mnt/d/rsync.log" \
  "/mnt/e/rsync.log"
