#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/functions.sh"
source "$DIR/manage-instance-profiles.sh"
echo "Functions loaded into memory."