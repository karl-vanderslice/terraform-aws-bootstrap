# AGENTS

## Purpose

This repository bootstraps AWS account foundation resources and related access
primitives.

## Documentation Standards

- Keep `README.md` as the GitHub entrypoint and `docs/index.md` as the docs
  landing page.
- Do not add duplicate overview pages such as `docs/README.md`.
- Keep Terraform variable, output, and module descriptions complete enough for
  `terraform-docs`; generated Markdown is the canonical reference surface.
- Prefer `just` targets in docs when they exist instead of duplicating raw
  Terraform and shell commands.
- Keep credential flow, state backend notes, and account-guardrail rationale in
  task or explanation docs, not in generated reference tables.
