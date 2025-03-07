#!/bin/bash
set -a
source /etc/environment
set +a

# Detect architecture
ARCH=$(uname -m)

# Set binary path based on architecture
if [[ "$ARCH" == "x86_64" ]]; then
    DOW_BINARY="/app/dow-amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    DOW_BINARY="/app/dow-arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Make sure the binary is executable
chmod +x $DOW_BINARY

# Execute dow with proper environment variables
$DOW_BINARY --url $SONARR_URL --key $SONARR_API_KEY