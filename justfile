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

bw-push:
  #!/usr/bin/env bash
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
  EXISTING=$(bw list items --search "AWS Bootstrap Outputs" 2>/dev/null | python3 -c "import sys,json; items=json.load(sys.stdin); print(items[0]['id'] if items else '')" 2>/dev/null || echo "")
  PAYLOAD=$(python3 -c "
  import json, sys
  item = {
    'organizationId': None,
    'collectionIds': [],
    'type': 2,
    'name': 'AWS Bootstrap Outputs',
    'notes': '',
    'fields': [
      {'name': 'OPS_BUCKET_NAME',              'value': '$BUCKET',       'type': 0},
      {'name': 'OPS_BUCKET_ARN',               'value': '$BUCKET_ARN',   'type': 0},
      {'name': 'OPS_BUCKET_ACCESS_KEY_ID',     'value': '$OPS_KEY',      'type': 0},
      {'name': 'OPS_BUCKET_SECRET_ACCESS_KEY', 'value': '$OPS_SECRET',   'type': 1},
      {'name': 'VAULT_IAM_ACCESS_KEY_ID',      'value': '$VAULT_KEY',    'type': 0},
      {'name': 'VAULT_IAM_SECRET_ACCESS_KEY',  'value': '$VAULT_SECRET', 'type': 1},
      {'name': 'AWS_MCP_ACCESS_KEY_ID',        'value': '$AWS_MCP_KEY',  'type': 0},
      {'name': 'AWS_MCP_SECRET_ACCESS_KEY',    'value': '$AWS_MCP_SECRET', 'type': 1},
      {'name': 'AWS_MCP_REGION',               'value': '$AWS_REGION',   'type': 0},
    ]
  }
  print(json.dumps(item))
  ")
  if [[ -z "${EXISTING}" ]]; then
    ITEM_JSON=$(echo "${PAYLOAD}" | bw encode | bw create item)
    ITEM_ID=$(echo "${ITEM_JSON}" | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")
    ORG_ID=$(bw list organizations 2>/dev/null | python3 -c "import sys,json; orgs=json.load(sys.stdin); print(next((o['id'] for o in orgs if 'ai' in o['name'].lower()), orgs[0]['id'])" 2>/dev/null || echo "")
    COLL_ID=$(bw list org-collections --organizationid "${ORG_ID}" 2>/dev/null | python3 -c "import sys,json; colls=json.load(sys.stdin); print(next((c['id'] for c in colls if 'shared' in c['name'].lower()), ''))" 2>/dev/null || echo "")
    if [[ -n "${ORG_ID}" && -n "${COLL_ID}" ]]; then
      bw share "${ITEM_ID}" "${ORG_ID}" "${COLL_ID}" > /dev/null
    fi
  else
    bw get item "${EXISTING}" | python3 -c "
  import sys, json
  item = json.load(sys.stdin)
  new_fields = json.loads('$PAYLOAD')['fields']
  item['fields'] = new_fields
  print(json.dumps(item))
  " | bw encode | bw edit item "${EXISTING}" > /dev/null
  fi
  echo "Bitwarden item 'AWS Bootstrap Outputs' updated."
