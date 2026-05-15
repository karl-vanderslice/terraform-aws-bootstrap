default:
  @just --list

fmt:
  nix develop -c terraform fmt -recursive

init:
  nix develop -c terraform init -upgrade

validate:
  nix develop -c terraform init -backend=false
  nix develop -c terraform validate

plan:
  nix develop -c terraform plan

apply:
  nix develop -c terraform apply -auto-approve

checkov:
  nix develop -c checkov -d . --config-file .checkov.yaml

lint:
  nix flake check --print-build-logs

pre-commit:
  nix build .#checks.x86_64-linux.pre-commit

install-hooks:
  nix develop -c true

ci:
  just lint

terraform-docs:
  nix develop -c terraform-docs markdown table --output-file README.md --output-mode inject .

rbw-push:
  set -euo pipefail
  BUCKET=$(nix develop -c terraform output -raw ops_bucket_name)
  BUCKET_ARN=$(nix develop -c terraform output -raw ops_bucket_arn)
  OPS_KEY=$(nix develop -c terraform output -raw ops_bucket_access_key_id)
  OPS_SECRET=$(nix develop -c terraform output -raw ops_bucket_secret_access_key)
  VAULT_KEY=$(nix develop -c terraform output -raw vault_iam_access_key_id)
  VAULT_SECRET=$(nix develop -c terraform output -raw vault_iam_secret_access_key)
  AWS_MCP_KEY=$(nix develop -c terraform output -raw aws_mcp_access_key_id)
  AWS_MCP_SECRET=$(nix develop -c terraform output -raw aws_mcp_secret_access_key)
  AWS_REGION=$(nix develop -c terraform output -raw aws_region)
  PAYLOAD=$(jq -nc \
    --arg OPS_BUCKET_NAME "$BUCKET" \
    --arg OPS_BUCKET_ARN "$BUCKET_ARN" \
    --arg OPS_BUCKET_ACCESS_KEY_ID "$OPS_KEY" \
    --arg OPS_BUCKET_SECRET_ACCESS_KEY "$OPS_SECRET" \
    --arg VAULT_IAM_ACCESS_KEY_ID "$VAULT_KEY" \
    --arg VAULT_IAM_SECRET_ACCESS_KEY "$VAULT_SECRET" \
    --arg AWS_MCP_ACCESS_KEY_ID "$AWS_MCP_KEY" \
    --arg AWS_MCP_SECRET_ACCESS_KEY "$AWS_MCP_SECRET" \
    --arg AWS_MCP_REGION "$AWS_REGION" \
    '{OPS_BUCKET_NAME:$OPS_BUCKET_NAME,OPS_BUCKET_ARN:$OPS_BUCKET_ARN,OPS_BUCKET_ACCESS_KEY_ID:$OPS_BUCKET_ACCESS_KEY_ID,OPS_BUCKET_SECRET_ACCESS_KEY:$OPS_BUCKET_SECRET_ACCESS_KEY,VAULT_IAM_ACCESS_KEY_ID:$VAULT_IAM_ACCESS_KEY_ID,VAULT_IAM_SECRET_ACCESS_KEY:$VAULT_IAM_SECRET_ACCESS_KEY,AWS_MCP_ACCESS_KEY_ID:$AWS_MCP_ACCESS_KEY_ID,AWS_MCP_SECRET_ACCESS_KEY:$AWS_MCP_SECRET_ACCESS_KEY,AWS_MCP_REGION:$AWS_MCP_REGION}')
  rbw unlock >/dev/null
  rbw sync >/dev/null
  tmp_note=$(mktemp)
  printf 'managed-by-terraform-aws-bootstrap\n%s\n' "$PAYLOAD" >"$tmp_note"
  tmp_editor=$(mktemp)
  printf '%s\n' '#!/usr/bin/env bash' 'set -euo pipefail' 'cat "$TMP_RBW_NOTE" >"$1"' >"$tmp_editor"
  chmod +x "$tmp_editor"
  if rbw get "AWS Bootstrap Outputs" >/dev/null 2>&1; then
  TMP_RBW_NOTE="$tmp_note" EDITOR="$tmp_editor" rbw edit "AWS Bootstrap Outputs" >/dev/null
  else
  TMP_RBW_NOTE="$tmp_note" EDITOR="$tmp_editor" rbw add "AWS Bootstrap Outputs" >/dev/null
  fi
  rm -f "$tmp_note" "$tmp_editor"
  echo "rbw item 'AWS Bootstrap Outputs' updated."
