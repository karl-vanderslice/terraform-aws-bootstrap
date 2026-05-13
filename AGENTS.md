# AGENTS

## Snapshot

- Purpose: this repo bootstraps AWS account foundation resources and related
  access primitives.
- Load order: load this file first. Repo-local prompt/skill overlays are not
  present yet.
- Primary docs: `README.md`, `docs/index.md`, and generated `terraform-docs`
  reference blocks.

## Working Rules

- Keep Terraform variable, output, and module descriptions complete enough for
  `terraform-docs`; generated Markdown is the canonical reference surface.
- Prefer `just` targets in docs when they exist instead of duplicating raw
  Terraform and shell commands.
- Keep credential flow, state backend notes, and account guardrail rationale in
  explanation docs, not in generated reference tables.
- Do not add duplicate overview pages such as `docs/README.md`.
