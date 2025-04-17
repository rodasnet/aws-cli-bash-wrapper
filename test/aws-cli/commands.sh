#!/usr/bin/env bats

TEST_DIR="$DIR/test/aws-cli"
TEST_FILE="$TEST_DIR/commands.sh"

mkdir -p "$TEST_DIR"

# Store the unit tests
cat << 'EOF' > "$TEST_FILE"
#!/usr/bin/env bats

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_TEMPLATES_PATH="$DIR/../../lib/templates/s3.json"

source "$DIR/../../functions.sh"

setup() {
    mkdir -p "$DIR/../../lib/templates"
    echo '{ "BucketName": "{{BucketName}}" }' > "$LIB_TEMPLATES_PATH"

    function aws() {
        echo "Mock AWS execution: $@"
    }
}

@test "Fails if bucket name is not provided" {
    run create_s3_bucket
    [ "$status" -eq 1 ]
    [[ "${output}" =~ "Error: Bucket name must be specified" ]]
}

@test "Uses default template file when --template-file is not provided" {
    run create_s3_bucket -n test-bucket
    [[ "${output}" =~ "$LIB_TEMPLATES_PATH" ]]
}

@test "Fails if specified template file does not exist" {
    run create_s3_bucket -n test-bucket --template-file /invalid/path.json
    [ "$status" -eq 1 ]
    [[ "${output}" =~ "Error: JSON template file '/invalid/path.json' not found" ]]
}

@test "Executes AWS CLI with resolved JSON" {
    run create_s3_bucket -n test-bucket
    [[ "${output}" =~ "Mock AWS execution: s3api create-bucket" ]]
    [[ "${output}" =~ "test-bucket" ]]
}

@test "Handles dry-run flag correctly" {
    run create_s3_bucket -n test-bucket --dry-run
    [[ "${output}" =~ "Dry run enabled. Skipping bucket creation." ]]
}

teardown() {
    rm -rf "$DIR/../../lib/templates"
}
EOF

chmod +x "$TEST_FILE"

echo "Unit tests stored in '$TEST_FILE'. Run with: bats $TEST_FILE"