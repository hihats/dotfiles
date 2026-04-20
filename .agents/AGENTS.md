# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this machine globally.

## Must
- Always plan mode
- When requested to conduct an investigation, always consult official documentation first and ensure that the source is cited at the end of the findings.
- Write
  * In code, write How
  * In test code, write What
  * In commit logs, write Why
  * In code comments, write Why not
- Check to see if there are any inconsistencies with previous conversations, and if there are, be honest about them
- At the end of the response, explicitly state whether there were any signs of sycophancy

## Recommend
> Note: These are personal guidelines, not official recommendations.
- Content intended for humans should be written in README
- Content intended for both humans and AI should be written in both README & AGENTS.md (CLAUDE.md)
  * However, vary the level of detail

  - README: Human-facing details (usage, concrete examples, background explanation)
  - CLAUDE.md: Only the key points AI needs to make work decisions

  For example, Rate Limits should be documented in both CLAUDE.md and README.
  However, for README, a high-level explanation like "these limitations exist" is sufficient,
  while CLAUDE.md needs implementation-level details like "use this sleep value when writing code"
