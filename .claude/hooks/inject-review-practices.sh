#!/usr/bin/env bash
# コードレビュー系のスキル / コマンドが起動したとき、documents/code_review_practices.md を
# 読むよう additionalContext で指示する。
#
# 2 つのイベントから同じスクリプトを呼ぶ:
#   - UserPromptExpansion: ユーザーが /code-review などを入力したとき（stdin に command_name）
#   - PreToolUse(Skill):   モデルが自発的に Skill ツールを呼んだとき（stdin に tool_input.skill）
#
# CLAUDE.md 等に書かず hook にしているのは、文書の参照を「モデルが思い出すか」に依存させないため。
set -euo pipefail

REVIEW_SKILLS='^(code-review|security-review|simplify|dependabot-review-.*)$'
PRACTICES_DOC='documents/code_review_practices.md'
DEBUG_DIR="${REVIEW_HOOK_DEBUG_DIR:-${HOME}/.claude/logs}"

input="$(cat)"

# stdin のフィールド名（特に PreToolUse の Skill 用）は公式ドキュメントに載っていないため、
# イベントごとに初回だけ生データを残して確認できるようにする。2 回目以降は何もしない。
log_once() {
  local event="$1"
  local log_file="${DEBUG_DIR}/skill-hook-${event}.json"
  [ -f "$log_file" ] && return 0
  mkdir -p "$DEBUG_DIR"
  printf '%s\n' "$input" > "$log_file"
}

skill_name() {
  jq -r '
    if .hook_event_name == "UserPromptExpansion" then (.command_name // "")
    elif .hook_event_name == "PreToolUse" then (.tool_input.skill // "")
    else "" end' <<<"$input"
}

emit_context() {
  local event="$1"
  local message
  message="コードレビュー系のスキルが起動しました。Standards 軸の基準として、リポジトリの ${PRACTICES_DOC} も読んでください。"
  message+="該当する項目は節番号と強制力表記（MUST / 推奨 / 好み）つきで引用してください。"
  message+="この文書は 1 人のレビュワーの判断の記録であり、チームの合意事項ではないと冒頭に明記されています。"
  message+="MUST 表記の項目でも、PR へのコメントは [IMO] を基本にしてください。"
  message+="あわせて CLAUDE.md の観点も含めてください。読み込まれているすべての CLAUDE.md（ユーザー global、プロジェクト、AGENTS.md）の規約を基準に加え、"
  message+="変更された関数・クラスごとに循環的複雑度、凝集度、結合度を評価し、コード・テスト・コミットログ・コメントの書き分け（How / What / Why / Why not）も確認してください。"
  jq -cn --arg event "$event" --arg message "$message" \
    '{hookSpecificOutput: {hookEventName: $event, additionalContext: $message}}'
}

main() {
  local event name
  # hook の失敗は既定で非ブロッキングだが、JSON でない stdin で jq のエラーを毎回表示させない
  jq -e . <<<"$input" >/dev/null 2>&1 || exit 0
  event="$(jq -r '.hook_event_name // ""' <<<"$input")"
  log_once "$event"
  name="$(skill_name)"
  [[ "$name" =~ $REVIEW_SKILLS ]] || exit 0
  [ -f "${CLAUDE_PROJECT_DIR:-.}/${PRACTICES_DOC}" ] || exit 0
  emit_context "$event"
}

main
