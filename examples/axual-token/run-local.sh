#!/bin/sh

#
# Builds the provider from the local repo checkout, tagging it with the
# current repo's release version (from `git describe`, matching how
# .goreleaser.yml injects -X main.version for real releases), then runs
# Terraform against this example directory using a dev_overrides config
# pointing at that local build. No `terraform init` needed - dev_overrides
# bypasses provider version/source resolution entirely.
#
# Usage: ./run-local.sh [plan|apply|destroy] [extra terraform args...]
#   AXUAL_AUTH_TOKEN   bearer token to authenticate with (or edit provider.tf directly)
#

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
EXAMPLE_DIR="$ROOT_DIR/examples/axual-token"
OUTPUT_DIR="$ROOT_DIR/.local/provider"
CLI_CONFIG="$ROOT_DIR/.local/terraform.rc"

CMD="${1:-plan}"
[ "$#" -gt 0 ] && shift

VERSION=$(git -C "$ROOT_DIR" describe --tags --abbrev=0 2>/dev/null | sed 's/^v//') || VERSION=""
VERSION=${VERSION:-dev}

mkdir -p "$OUTPUT_DIR"

cat > "$CLI_CONFIG" <<EOF
provider_installation {
	dev_overrides {
		"Axual/axual" = "$OUTPUT_DIR"
	}

	direct {}
}
EOF

printf '%s\n' "Building local Axual provider (version $VERSION)..."
go build -trimpath -ldflags "-X main.version=$VERSION" -o "$OUTPUT_DIR/terraform-provider-axual" "$ROOT_DIR"
printf '%s\n' "Built $OUTPUT_DIR/terraform-provider-axual"

if [ -z "${AXUAL_AUTH_TOKEN:-}" ] && grep -q 'PLEASE_CHANGE_TOKEN' "$EXAMPLE_DIR/provider.tf"; then
	printf '\n%s\n' "WARNING: AXUAL_AUTH_TOKEN is not set and $EXAMPLE_DIR/provider.tf still has the placeholder token."
	printf '%s\n' "Export AXUAL_AUTH_TOKEN=<your token>, or edit provider.tf directly, before continuing."
fi

printf '\n%s\n' "Running 'terraform $CMD' in $EXAMPLE_DIR via dev_overrides (local build, no terraform init)..."
TF_CLI_CONFIG_FILE="$CLI_CONFIG" terraform -chdir="$EXAMPLE_DIR" "$CMD" "$@"
