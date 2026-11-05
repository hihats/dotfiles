#!/usr/bin/env bash
# コードレビュー系のスキル / コマンドが起動したとき、リポジトリ内の code_review_practices.md を
# 読むよう additionalContext で指示する。
#
# 2 つのイベントから同じスクリプトを呼ぶ:
#   - UserPromptExpansion: ユーザーが /code-review などを入力したとき（stdin に command_name）
#   - PreToolUse(Skill):   モデルが自発的に Skill ツールを呼んだとき（stdin に tool_input.skill）
#
# CLAUDE.md 等に書かず hook にしているのは、文書の参照を「モデルが思い出すか」に依存させないため。
set -euo pipefail

# プラグインのスキルは `plugin:skill` 形式で来るので、先頭の名前空間は任意にしてスキル名だけで判定する
REVIEW_SKILLS='^([^:]+:)?(code-review|security-review|simplify|dependabot-review-.*)$'
# 置き場所を固定しないのは、リポジトリごとに documents/ や docs/ と異なるため
PRACTICES_DOC_RE='(^|/)code_review_practices\.md$'

input="$(cat)"

skill_name() {
  jq -r '
    if .hook_event_name == "UserPromptExpansion" then (.command_name // "")
    elif .hook_event_name == "PreToolUse" then (.tool_input.skill // "")
    else "" end' <<<"$input"
}

# CLAUDE_PROJECT_DIR を使わないのは、worktree に入ってもセッション開始時のディレクトリに据え置かれるため。
# hook 入力の cwd は worktree に追従する（公式 hooks ドキュメント）
project_root() {
  local cwd
  cwd="$(jq -r '.cwd // ""' <<<"$input")"
  [ -n "$cwd" ] || cwd="${CLAUDE_PROJECT_DIR:-.}"
  git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || printf '%s\n' "$cwd"
}

# 追跡ファイルだけを対象にするのは、node_modules 等を走査しないためと、
# 未追跡の下書きを規約として扱わないため。非 git ディレクトリでは空になる
practices_docs() {
  local root="$1"
  git -C "$root" ls-files 2>/dev/null | grep -E "$PRACTICES_DOC_RE" || true
}

emit_context() {
  local event="$1" root="$2" docs="$3"
  local message
  message="コードレビュー系のスキルが起動しました。Standards 軸の基準として、リポジトリ ${root} の ${docs} も読んでください。"
  message+="該当する項目は節番号と強制力表記（MUST / 推奨 / 好み）つきで引用してください。"
  message+="この文書は 1 人のレビュワーの判断の記録であり、チームの合意事項ではないと冒頭に明記されています。"
  message+="MUST 表記の項目でも、PR へのコメントは [IMO] を基本にしてください。"
  message+="あわせて CLAUDE.md の観点も含めてください。読み込まれているすべての CLAUDE.md（ユーザー global、プロジェクト、AGENTS.md）の規約を基準に加え、"
  message+="変更された関数・クラスごとに循環的複雑度、凝集度、結合度を評価し、コード・テスト・コミットログ・コメントの書き分け（How / What / Why / Why not）も確認してください。"
  jq -cn --arg event "$event" --arg message "$message" \
    '{hookSpecificOutput: {hookEventName: $event, additionalContext: $message}}'
}

main() {
  local event name root docs
  # hook の失敗は既定で非ブロッキングだが、JSON でない stdin で jq のエラーを毎回表示させない
  jq -e . <<<"$input" >/dev/null 2>&1 || exit 0
  event="$(jq -r '.hook_event_name // ""' <<<"$input")"
  name="$(skill_name)"
  [[ "$name" =~ $REVIEW_SKILLS ]] || exit 0
  root="$(project_root)"
  docs="$(practices_docs "$root" | paste -sd, -)"
  [ -n "$docs" ] || exit 0
  emit_context "$event" "$root" "$docs"
}

main
