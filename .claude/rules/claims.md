# Claims and recommendations

Applies to investigations, design discussions and Q&A in any project. Memory is per-project, so this lives here.

- Before calling existing behavior "intentional" or "a design decision", separate three things and label each: what the **code** does, what the **record** shows people decided (review threads via `gh api repos/.../pulls/N/comments`, commits before and after), and your **inference**. A PR description explains a change; it is not evidence that the resulting behavior was intended
- Before a negative assertion such as "there is nothing the caller can do", "this has no user-visible effect" or "this does not affect X", enumerate the concrete paths (UI routes, callers, states) and check each one. A changed message shown to the user counts as a changed action
- When recommending an option, write the reason in one sentence and name any unverified premise in it. If the reason is only "smaller" or "cleaner", do not mark it as recommended
- Failure examples that produced this rule:
  - 2026-10-15, crowdworks: wrote that a 400 reaching Rollbar was "an intentional decision" from the PR text alone. The review thread of an earlier PR had agreed the opposite; an eslint `no-empty` workaround had inverted it by accident. Pushed back twice
  - 2026-10-15, crowdworks: recommended not splitting 409 from 400 because "the frontend has no action to take either way". The answer path could show an "already answered" message, and was in fact showing a false "thank you". Pushed back once
  - 2026-10-08, slackapp: recommended "minimal" output fields with no reason for dropping `ts`; introduced a script as "extracts the user's posts" when it also collected mentions
