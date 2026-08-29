#!/bin/bash
# Claude Code status line — recreated (not wrapped) from the Starship config:
#   ~/.config/starship.toml -> ~/Documents/dotfiles/starship/starship.toml
#
# Self-contained: does NOT shell out to `starship prompt`. Each segment is
# rebuilt directly from Claude Code's stdin JSON + local git/kubectl lookups.
#
# Segments (left to right), same powerline style / palette as starship:
#   1. directory         bg #DA627D  (truncation_length=3, "…/" symbol,
#                                      [directory.substitutions] icons)
#   2. git branch+status bg #FCA17D  (branch symbol, ●N dirty, ⇡N/⇣N ahead/behind)
#   3. kubernetes ctx     bg #06969A  (☸ context (namespace); only when a
#                                      kubeconfig is in play — mirrors
#                                      starship's [kubernetes] detect_files/
#                                      detect_folders)
#   4. Claude model name  bg #33658A  (replaces starship's $time segment)
#
# No network calls: kubectl config current-context / config view --minify
# only read the local kubeconfig file, never contact a cluster.

input=$(cat)

cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty' 2>/dev/null)
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty' 2>/dev/null)
[ -z "$cwd" ] && cwd="$PWD"

# ---- palette (RGB, matches starship.toml hex values) ----
DIR_BG="218;98;125"     # #DA627D
GIT_BG="252;161;125"    # #FCA17D
K8S_BG="6;150;154"      # #06969A
MODEL_BG="51;101;138"   # #33658A
TEXT_FG="255;255;255"

SEP=""
RESET=$'\033[0m'

fg() { printf '\033[38;2;%sm' "$1"; }
bg() { printf '\033[48;2;%sm' "$1"; }

# ---------------------------------------------------------------------------
# directory segment — mirrors [directory]: truncation_length=3,
# truncation_symbol="…/", plus [directory.substitutions]
# ---------------------------------------------------------------------------
build_dir_segment() {
  local path="$cwd" home="$HOME" display
  if [ "$path" = "$home" ]; then
    display="~"
  elif [[ "$path" == "$home"/* ]]; then
    display="~${path#"$home"}"
  else
    display="$path"
  fi

  local comps=()
  IFS='/' read -r -a comps <<< "$display"

  local filtered=()
  local c
  for c in "${comps[@]}"; do
    [ -n "$c" ] && filtered+=("$c")
  done

  local i
  for i in "${!filtered[@]}"; do
    case "${filtered[$i]}" in
      "Documents") filtered[$i]="󰈙 " ;;
      "Downloads") filtered[$i]=" " ;;
      "Music")     filtered[$i]=" " ;;
      "Pictures")  filtered[$i]=" " ;;
    esac
  done

  local total=${#filtered[@]}
  local trunc_len=3
  local out="" start j

  if [ "$total" -gt "$trunc_len" ]; then
    out="…/"
    start=$((total - trunc_len))
  else
    start=0
  fi

  for ((j = start; j < total; j++)); do
    out="${out}${filtered[$j]}"
    [ "$j" -lt "$((total - 1))" ] && out="${out}/"
  done

  printf '%s' "$out"
}

# ---------------------------------------------------------------------------
# git segment — mirrors [git_branch] (symbol ) + [git_status]
# (simplified per spec: ●N for total dirty files, ⇡N/⇣N ahead/behind upstream)
# git commands skip optional locks so the status line never blocks/contends
# with a concurrent git operation.
# ---------------------------------------------------------------------------
build_git_segment() {
  command -v git >/dev/null 2>&1 || return 1
  git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 1

  local branch
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --quiet --short HEAD 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  [ -z "$branch" ] && return 1

  local dirty status_str="" ahead_behind ahead behind
  dirty=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  [ "${dirty:-0}" -gt 0 ] 2>/dev/null && status_str="●${dirty}"

  ahead_behind=$(git -C "$cwd" --no-optional-locks rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)
  if [ -n "$ahead_behind" ]; then
    behind=$(printf '%s' "$ahead_behind" | awk '{print $1}')
    ahead=$(printf '%s' "$ahead_behind" | awk '{print $2}')
    [ "${ahead:-0}" -gt 0 ] 2>/dev/null && status_str="${status_str}⇡${ahead}"
    [ "${behind:-0}" -gt 0 ] 2>/dev/null && status_str="${status_str}⇣${behind}"
  fi

  local out="  ${branch} "
  [ -n "$status_str" ] && out="${out}${status_str} "
  printf '%s' "$out"
}

# ---------------------------------------------------------------------------
# kubernetes segment — mirrors [kubernetes] detect_files/detect_folders
# (['kubeconfig','.kubeconfig'] files / ['.kube'] folder, checked in cwd —
# same scope starship itself uses), symbol ☸. Skipped entirely if not
# detected, or if no context can be resolved.
# ---------------------------------------------------------------------------
build_k8s_segment() {
  local detected=0
  [ -f "$cwd/kubeconfig" ] && detected=1
  [ -f "$cwd/.kubeconfig" ] && detected=1
  [ -d "$cwd/.kube" ] && detected=1
  [ "$detected" -eq 1 ] || return 1

  local kubeconfig="${KUBECONFIG:-$HOME/.kube/config}"
  [ -f "$kubeconfig" ] || return 1

  local ctx ns=""
  if command -v kubectl >/dev/null 2>&1; then
    ctx=$(kubectl config current-context 2>/dev/null)
    [ -z "$ctx" ] && return 1
    ns=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null)
  else
    ctx=$(awk '/^current-context:/{print $2; exit}' "$kubeconfig" 2>/dev/null)
    [ -z "$ctx" ] && return 1
  fi

  if [ -n "$ns" ]; then
    printf ' ☸ %s (%s) ' "$ctx" "$ns"
  else
    printf ' ☸ %s ' "$ctx"
  fi
}

# ---------------------------------------------------------------------------
# assemble segments (powerline chain, only present segments are rendered)
# ---------------------------------------------------------------------------
dir_text=" $(build_dir_segment) "
git_text=$(build_git_segment)
k8s_text=$(build_k8s_segment)

bgs=("$DIR_BG")
texts=("$dir_text")

if [ -n "$git_text" ]; then
  bgs+=("$GIT_BG")
  texts+=("$git_text")
fi

if [ -n "$k8s_text" ]; then
  bgs+=("$K8S_BG")
  texts+=("$k8s_text")
fi

if [ -n "$model" ]; then
  bgs+=("$MODEL_BG")
  texts+=(" ${model} ")
fi

out=""
n=${#bgs[@]}
prev=""
for ((i = 0; i < n; i++)); do
  cur="${bgs[$i]}"
  out="${out}${RESET}"
  if [ -n "$prev" ]; then
    out="${out}$(fg "$prev")$(bg "$cur")"
  else
    out="${out}$(fg "$cur")"
  fi
  out="${out}${SEP}"
  out="${out}${RESET}$(bg "$cur")$(fg "$TEXT_FG")${texts[$i]}"
  prev="$cur"
done
out="${out}${RESET} "

printf '%s\n' "$out"
