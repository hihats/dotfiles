#!/bin/bash
#
# check-node-versions.sh
#
# このMac上の Node.js 実体（Homebrew / nodenv / PATH / asdf）と、プロジェクトの
# .node-version 等のピン留めを nodejs.org のリリース情報と突き合わせ、
# セキュリティ修正版より古いもの・EOL 系列を報告する。
#
# 修復は行わない。表示した Actions を人が実行する。
#
# Usage:
#   ./check-node-versions.sh [VERSION ...]   # 引数のバージョンも判定対象に加える
# Exit:
#   0 = 全て OK / OUTDATED（非セキュリティ更新のみ）
#   1 = NEEDS_UPDATE か EOL が1件以上
#   2 = 前提ツール不足またはリリース情報の取得失敗

set -euo pipefail

RELEASE_INDEX_URL="${NODE_RELEASE_INDEX_URL:-https://nodejs.org/dist/index.json}"
SCHEDULE_URL="${NODE_SCHEDULE_URL:-https://raw.githubusercontent.com/nodejs/Release/main/schedule.json}"
PROJECT_ROOT="${NODE_CHECK_PROJECT_ROOT:-$HOME/github}"
NODENV_ROOT="${NODENV_ROOT:-$HOME/.nodenv}"
TODAY="$(date +%Y-%m-%d)"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT
INDEX_JSON="$WORKDIR/index.json"
SCHEDULE_JSON="$WORKDIR/schedule.json"
NODE_BUILD_LIST="$WORKDIR/node-build.txt"

# ---------- prerequisites ----------

require_tools() {
  local t
  for t in "$@"; do
    command -v "$t" >/dev/null || { echo "ERROR: $t is required" >&2; exit 2; }
  done
}

fetch_json() { # $1=url $2=dest
  if ! curl -fsSL --max-time 30 "$1" -o "$2"; then
    echo "ERROR: failed to fetch $1" >&2
    exit 2
  fi
}

load_node_build_definitions() {
  # nodenv が無ければ空ファイル。後段の grep が「定義を知らない」と判定する
  : >"$NODE_BUILD_LIST"
  command -v nodenv >/dev/null || return 0
  nodenv install -l 2>/dev/null | grep -E '^[0-9]+\.' >"$NODE_BUILD_LIST" || true
}

# ---------- discovery: emits "source<TAB>version<TAB>location" ----------

discover_homebrew() {
  command -v brew >/dev/null || return 0
  HOMEBREW_NO_AUTO_UPDATE=1 brew list --versions 2>/dev/null |
    awk '$1 ~ /^node(@[0-9]+)?$/ { for (i = 2; i <= NF; i++) printf "homebrew:%s\t%s\tbrew formula %s\n", $1, $i, $1 }'
}

discover_nodenv() {
  local dir="$NODENV_ROOT/versions" v
  [ -d "$dir" ] || return 0
  for v in "$dir"/*/; do
    [ -d "$v" ] || continue
    printf 'nodenv\t%s\t%s\n' "$(basename "$v")" "$v"
  done
}

discover_path() {
  # Homebrew / nodenv 配下に解決される node は上の2関数で数えるので除外し、
  # それ以外の経路（手動配置など）だけを拾う
  local bin ver real
  while IFS= read -r bin; do
    real="$(realpath "$bin" 2>/dev/null || echo "$bin")"
    is_managed_path "$real" && continue
    ver="$("$bin" --version 2>/dev/null | sed 's/^v//')" || continue
    printf 'PATH\t%s\t%s\n' "$ver" "$bin"
  done < <(which -a node 2>/dev/null | sort -u)
}

is_managed_path() { # $1=resolved path
  local brew_prefix
  brew_prefix="$(brew --prefix 2>/dev/null || echo /nonexistent)"
  [[ "$1" == "$brew_prefix"/* ]] || [[ "$1" == "$NODENV_ROOT"/* ]]
}

discover_asdf() {
  command -v asdf >/dev/null || return 0
  asdf plugin list 2>/dev/null | grep -qx nodejs || return 0
  asdf list nodejs 2>/dev/null | tr -d ' *' | sed '/^$/d' |
    awk '{ printf "asdf\t%s\tasdf:nodejs\n", $1 }'
}

discover_pinned() {
  local f
  while IFS= read -r f; do
    emit_pin_from_file "$f"
  done < <(find "$PROJECT_ROOT" -maxdepth 3 \( -name .node-version -o -name .nvmrc -o -name .tool-versions \) \
    -not -path '*/node_modules/*' 2>/dev/null | sort)
}

emit_pin_from_file() { # $1=pin file
  local f="$1" ver
  case "$(basename "$f")" in
    .tool-versions) ver="$(awk '$1 == "nodejs" { print $2 }' "$f")" ;;
    *) ver="$(head -1 "$f" | tr -d '[:space:]' | sed 's/^v//')" ;;
  esac
  if [ -n "$ver" ]; then
    printf 'pin\t%s\t%s %s\n' "$ver" "$f" "$(pin_install_state "$ver")"
  fi
}

pin_install_state() { # $1=version
  if [ -d "$NODENV_ROOT/versions/$1" ]; then echo "(installed)"; else echo "(NOT installed)"; fi
}

discover_args() {
  local v
  for v in "$@"; do
    printf 'arg\t%s\tcommand-line argument\n' "${v#v}"
  done
}

# ---------- judgement ----------

is_exact_version() { [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; }

version_lt() { # $1 < $2
  [ "$1" != "$2" ] && [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -1)" = "$1" ]
}

line_facts() { # $1=major -> "latest<TAB>latest_security_release"
  # index.json は新しい順なので first が最新
  jq -r --arg m "$1" '
    [ .[] | select((.version | ltrimstr("v") | split(".")[0]) == $m) ] as $line
    | [ ($line | map(.version | ltrimstr("v")) | first // "-"),
        ($line | map(select(.security == true) | .version | ltrimstr("v")) | first // "-") ]
    | @tsv' "$INDEX_JSON"
}

line_end_date() { # $1=major
  jq -r --arg m "v$1" '.[$m].end // "-"' "$SCHEDULE_JSON"
}

is_eol() { [ "$1" != "-" ] && [[ "$1" < "$TODAY" ]]; }

is_behind() { [ "$2" != "-" ] && version_lt "$1" "$2"; }

judge_version() { # $1=version -> "STATUS<TAB>latest<TAB>fixed<TAB>end"
  local ver="$1" major latest fixed end status
  major="${ver%%.*}"
  IFS=$'\t' read -r latest fixed <<<"$(line_facts "$major")"
  end="$(line_end_date "$major")"
  if [ "$latest" = "-" ]; then status="UNKNOWN"
  elif is_eol "$end"; then status="EOL"
  elif is_behind "$ver" "$fixed"; then status="NEEDS_UPDATE"
  elif is_behind "$ver" "$latest"; then status="OUTDATED"
  else status="OK"
  fi
  printf '%s\t%s\t%s\t%s\n' "$status" "$latest" "$fixed" "$end"
}

judge_rows() { # stdin: source,version,location -> + status,latest,fixed,end
  local src ver loc
  while IFS=$'\t' read -r src ver loc; do
    if is_exact_version "$ver"; then
      printf '%s\t%s\t%s\t%s\n' "$src" "$ver" "$loc" "$(judge_version "$ver")"
    else
      printf '%s\t%s\t%s\tUNRESOLVED\t-\t-\t-\n' "$src" "$ver" "$loc"
    fi
  done
}

# ---------- report ----------

render_table() { # $1=judged tsv
  {
    printf 'SOURCE\tVERSION\tSTATUS\tLATEST\tSECURITY_FIX\tLINE_EOL\tLOCATION\n'
    awk -F'\t' 'BEGIN { OFS = "\t" } { print $1, $2, $4, $5, $6, $7, $3 }' "$1"
  } | column -t -s $'\t'
}

nodenv_install_cmd() { # $1=version
  if grep -qx "$1" "$NODE_BUILD_LIST"; then
    echo "nodenv install $1"
  else
    echo "brew upgrade node-build && nodenv install $1"
  fi
}

remediation_for_update() { # $1=src $2=ver $3=fixed $4=loc
  case "$1" in
    homebrew:*) printf -- '- %s %s -> %s: brew upgrade %s\n' "$1" "$2" "$3" "${1#homebrew:}" ;;
    nodenv) printf -- '- nodenv %s -> %s: %s, then repoint .node-version files\n' "$2" "$3" "$(nodenv_install_cmd "$3")" ;;
    pin) printf -- '- %s -> %s: %s, then update the pin file\n' "$4" "$3" "$(nodenv_install_cmd "$3")" ;;
    *) printf -- '- %s %s -> %s: install the fixed version (%s)\n' "$1" "$2" "$3" "$4" ;;
  esac
}

print_actions() { # $1=judged tsv
  local src ver loc status latest fixed end
  while IFS=$'\t' read -r src ver loc status latest fixed end; do
    case "$status" in
      NEEDS_UPDATE) remediation_for_update "$src" "$ver" "$fixed" "$loc" ;;
      EOL) printf -- '- %s %s (%s): line %s.x ended %s, move to a supported line (see https://github.com/nodejs/release#release-schedule)\n' "$src" "$ver" "$loc" "${ver%%.*}" "$end" ;;
      UNRESOLVED) printf -- '- %s pins "%s" (not an exact x.y.z), check manually\n' "$loc" "$ver" ;;
    esac
  done <"$1"
}

count_status() { # $1=judged tsv $2..=statuses
  local f="$1"
  shift
  awk -F'\t' -v want=" $* " 'index(want, " " $4 " ") { n++ } END { print n + 0 }' "$f"
}

print_bundled_info() {
  # アプリ同梱の node はアプリ側の更新で入れ替わるので判定結果は表示だけ（exit code に含めない）
  local bin rows="$WORKDIR/bundled.tsv"
  for bin in /Applications/Cursor.app/Contents/Resources/app/resources/helpers/node \
    "$HOME"/.cache/uv/archive-v0/*/playwright/driver/node; do
    [ -x "$bin" ] || continue
    printf 'bundled\t%s\t%s\n' "$("$bin" --version 2>/dev/null | sed 's/^v//')" "$bin"
  done | judge_rows >"$rows"
  [ -s "$rows" ] || return 0
  echo
  echo "== Bundled runtimes (informational, updated by their apps) =="
  render_table "$rows"
}

main() {
  require_tools curl jq
  fetch_json "$RELEASE_INDEX_URL" "$INDEX_JSON"
  fetch_json "$SCHEDULE_URL" "$SCHEDULE_JSON"
  load_node_build_definitions

  local judged="$WORKDIR/judged.tsv"
  {
    discover_homebrew
    discover_nodenv
    discover_path
    discover_asdf
    discover_pinned
    discover_args "$@"
  } | judge_rows >"$judged"

  echo "== Node runtimes and pins (as of $TODAY) =="
  render_table "$judged"
  echo
  echo "== Actions (not executed) =="
  if [ "$(count_status "$judged" NEEDS_UPDATE EOL UNRESOLVED)" -eq 0 ]; then
    echo "- none"
  fi
  print_actions "$judged"
  print_bundled_info

  [ "$(count_status "$judged" NEEDS_UPDATE EOL)" -eq 0 ]
}

main "$@"
