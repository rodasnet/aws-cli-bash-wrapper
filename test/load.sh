#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/functions.sh"
source "$DIR/../lib/functions.sh"
source "$DIR/../lib/aws-commands.sh"
source "$DIR/aws-cli/commands.sh"

echo "Test functions loaded into memory."