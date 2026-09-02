#!/bin/sh

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
OUTPUT_DIR="$ROOT_DIR/.local/provider"
CLI_CONFIG="$ROOT_DIR/.local/terraform.rc"

mkdir -p "$OUTPUT_DIR"

cat > "$CLI_CONFIG" <<EOF
provider_installation {
	dev_overrides {
		"Axual/axual" = "$OUTPUT_DIR"
	}

	direct {}
}
EOF

printf '%s\n' "Building local Axual provider..."
go build -trimpath -o "$OUTPUT_DIR/terraform-provider-axual" "$ROOT_DIR"

printf '\n%s\n' "Local provider built at $OUTPUT_DIR/terraform-provider-axual"
printf '%s\n' "Use it from a Terraform directory with:"
printf '  TF_CLI_CONFIG_FILE=%s terraform plan\n' "$CLI_CONFIG"