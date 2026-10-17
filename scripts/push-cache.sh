#!/usr/bin/env bash
#
# Filter store paths that other binary caches (e.g. cache.nixos.org) can
# already serve, print how many would actually be pushed, and optionally copy
# only the genuinely-new ones to the self-hosted Harmonia cache.
#
# Harmonia itself has no push-time filtering: it re-serves whatever reaches the
# destination store. Filtering has to happen on the client, which is what this
# script does by probing the configured "upstream" stores with `nix path-info`.
#
# Usage:
#   push-cache.sh [--dry-run] [--to STORE_URI] [--upstream STORE_URI]... PATH...
#   nix build .#hosts --print-out-paths --no-link | push-cache.sh --to ssh-ng://root@kintoru...
#
# Options:
#   --to URI         Destination store (default: $PUSH_CACHE_TO if set).
#   --upstream URI   A store to treat as already-having paths. Repeatable.
#                    Defaults to cache.nixos.org plus $PUSH_CACHE_UPSTREAM
#                    (colon-separated).
#   --substitute     Pass --substitute-on-destination to nix copy.
#   --dry-run        Only report; do not copy.
#   -h, --help       Show this help.

set -euo pipefail

to="${PUSH_CACHE_TO:-}"
substitute=0
dry_run=0
upstreams=()
paths=()

default_upstream="https://cache.nixos.org/"
if [[ -n "${PUSH_CACHE_UPSTREAM:-}" ]]; then
  IFS=: read -r -a extra <<<"${PUSH_CACHE_UPSTREAM}"
  upstreams+=("${extra[@]}")
else
  upstreams+=("${default_upstream}")
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --to) to="$2"; shift 2 ;;
    --upstream) upstreams+=("$2"); shift 2 ;;
    --substitute) substitute=1; shift ;;
    --dry-run) dry_run=1; shift ;;
    -h|--help) sed -n '2,30p' "$0" | sed 's/^# \?//'; exit 0 ;;
    --) shift; while [[ $# -gt 0 ]]; do paths+=("$1"); shift; done ;;
    -*) echo "unknown option: $1" >&2; exit 2 ;;
    *) paths+=("$1"); shift ;;
  esac
done

# Read paths from stdin when none were given as arguments.
if [[ ${#paths[@]} -eq 0 ]]; then
  while read -r line; do
    [[ -n "$line" ]] && paths+=("$line")
  done
fi

if [[ ${#paths[@]} -eq 0 ]]; then
  echo "error: no store paths given (pass them as args or on stdin)" >&2
  exit 2
fi

is_valid() {
  local store="$1" path="$2"
  nix path-info --store "$store" "$path" >/dev/null 2>&1
}

log() { echo "$@" >&2; }

# Expand each root to its full closure, de-duplicating.
log "Expanding closures of ${#paths[@]} root path(s)..."
declare -A seen
all=()
while read -r p; do
  [[ -z "$p" ]] && continue
  [[ -n "${seen[$p]:-}" ]] && continue
  seen[$p]=1
  all+=("$p")
done < <(nix-store --query --requisites "${paths[@]}")

log "Closure contains ${#all[@]} path(s)."

# A path is "already available" if any upstream store can serve it.
total=${#all[@]}
have=0
to_push=()

log "Probing ${#upstreams[@]} upstream store(s)..."
for p in "${all[@]}"; do
  found=0
  for store in "${upstreams[@]}"; do
    if is_valid "$store" "$p"; then found=1; break; fi
  done
  if (( found )); then
    have=$((have + 1))
  else
    to_push+=("$p")
  fi
done

log ""
log "Store paths in closure:            ${total}"
log "Already served by upstream:        ${have}"
log "To push to self-hosted cache:      ${#to_push[@]}"
log ""

if (( dry_run )); then
  printf '%s\n' "${to_push[@]}"
  exit 0
fi

if [[ -z "$to" ]]; then
  echo "error: no destination given; use --to or \$PUSH_CACHE_TO" >&2
  exit 2
fi

if [[ ${#to_push[@]} -eq 0 ]]; then
  log "Nothing new to push."
  exit 0
fi

log "Copying ${#to_push[@]} new path(s) to ${to}..."
copy_args=(--to "$to" --no-check-sigs)
(( substitute )) && copy_args+=(--substitute-on-destination)
nix copy "${copy_args[@]}" "${to_push[@]}"
