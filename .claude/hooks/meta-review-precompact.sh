#!/bin/sh
# PreCompact フック — meta-review の未実施からセッションを守る
#
#   block    : /compact(manual) のとき、meta-review 未実施なら一度だけ止める
#   preserve : auto compaction のとき、ユーザー発言だけを退避する（止めない）
#
# 異常時は必ず exit 0。フックの失敗でコンパクションを妨げない。

set -eu

action="${1:-}"
base="$HOME/.claude/meta-review"

# 何があっても止めないモードの既定
case "$action" in
  block|preserve) ;;
  *) exit 0 ;;
esac

command -v python3 >/dev/null 2>&1 || exit 0

input="$(cat 2>/dev/null || true)"
[ -n "$input" ] || exit 0

session_id="$(printf '%s' "$input" | python3 -c '
import json,sys
try:
    print(json.load(sys.stdin).get("session_id") or "")
except Exception:
    print("")
' 2>/dev/null || true)"
[ -n "$session_id" ] || exit 0

case "$session_id" in
  */*|..*) exit 0 ;;   # パス区切りを含む値は使わない
esac

if [ "$action" = "block" ]; then
  done_dir="$base/.done"
  mkdir -p "$done_dir" 2>/dev/null || exit 0
  # 実施済み、または通知済みなら素通り
  [ -e "$done_dir/$session_id" ] && exit 0
  [ -e "$done_dir/$session_id.warned" ] && exit 0
  : > "$done_dir/$session_id.warned" 2>/dev/null || exit 0
  cat >&2 <<'MSG'
このセッションでは meta-review がまだ実行されていません。
コンパクションすると指摘を拾うための文脈が失われます。先に /meta-review を実行してください。
不要であれば、もう一度 /compact を実行すればそのまま進みます。
MSG
  exit 2
fi

# preserve: transcript からユーザー発言だけを抜き出して退避する
transcript="$(printf '%s' "$input" | python3 -c '
import json,sys
try:
    print(json.load(sys.stdin).get("transcript_path") or "")
except Exception:
    print("")
' 2>/dev/null || true)"
[ -n "$transcript" ] && [ -r "$transcript" ] || exit 0

out_dir="$base/transcripts"
mkdir -p "$out_dir" 2>/dev/null || exit 0

TRANSCRIPT="$transcript" OUT="$out_dir/$session_id.md" SESSION="$session_id" python3 - <<'PY' 2>/dev/null || exit 0
import json, os, datetime

src, out, sid = os.environ["TRANSCRIPT"], os.environ["OUT"], os.environ["SESSION"]
rows = []
with open(src, encoding="utf-8", errors="replace") as f:
    for line in f:
        if not line.strip():
            continue
        try:
            r = json.loads(line)
        except json.JSONDecodeError:
            continue  # 壊れた行はスキップして継続
        if r.get("type") != "user" or r.get("isMeta"):
            continue
        c = r.get("message", {}).get("content")
        if isinstance(c, str) and c.strip():   # 文字列 content だけが実際の発言
            rows.append((r.get("timestamp", "")[:19], c))

tmp = out + ".tmp"
with open(tmp, "w", encoding="utf-8") as f:
    f.write(f"# ユーザー発言の退避（session {sid}）\n\n")
    f.write(f"auto compaction 直前に保存。{datetime.datetime.now().isoformat(timespec='seconds')}\n")
    f.write(f"元: `{src}`\n\n")
    f.write(f"発言 {len(rows)} 件。コンパクションで文脈が失われた場合、"
            f"meta-review の Step 1 はこのファイルを原文として読む。\n\n---\n\n")
    for ts, c in rows:
        f.write(f"## {ts}\n\n{c}\n\n")
os.replace(tmp, out)   # 途中で落ちても壊れたファイルを残さない
PY
exit 0
