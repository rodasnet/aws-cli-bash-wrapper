#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Test functions for the library
# This file contains test functions for the library methods.
# These functions are used to test the functionality of the library methods
# and ensure that they work as expected.
# They are not meant to be run directly, but rather called from the main script.
library_test_replace_json_values() {
    echo "Testing replace_json_values..."

    # Create a temporary JSON template
    local json_template="test_template.json"
    cat <<EOF > "$json_template"
{
    "name": "{{name}}",
    "age": "{{age}}",
    "city": "{{city}}"
}
EOF

    # Define expected output without leading spaces
    local expected_output='{
    "name": "Daniel",
    "age": "30",
    "city": "San Francisco"
}'

    # Run function with sample replacements
    local actual_output
    actual_output=$(replace_json_values "$json_template" "name=Daniel" "age=30" "city=San Francisco")

    # Normalize whitespace before comparison
    expected_output=$(echo "$expected_output" | sed -E 's/^[[:space:]]+//g')
    actual_output=$(echo "$actual_output" | sed -E 's/^[[:space:]]+//g')

    # Validate results
    if [[ "$actual_output" == "$expected_output" ]]; then
        echo "✅ Test Passed: JSON values replaced correctly!"
    else
        echo "❌ Test Failed: Expected output differs from actual output!"
        echo "Expected:"
        echo "$expected_output"
        echo "Got:"
        echo "$actual_output"
    fi

    # Clean up temporary files
    rm -f "$json_template"
}

library_test_function_serialize_user_params() {
    echo "Testing serialize_user_params..."

    # Define test cases
    local input1="--id 123 --json input.json --profile user1"
    local expected1="id=123 json=input.json profile=user1"

    # This test case has a bug where the single and double dashes
    # are handled the same and therefor could present a situation where there are duplicate keys
    local input2="--name Daniel --a 30 --city Tokyo"
    local expected2="name=Daniel a=30 city=Tokyo"

    local input3="--flag --option value --another 42"
    local expected3="option=value another=42"

    # Run function and capture output
    local output1=$(serialize_user_params $input1)
    local output2=$(serialize_user_params $input2)
    local output3=$(serialize_user_params $input3)

    # Validate results
    if [[ "$output1" == "$expected1" ]]; then
        echo "Test 1 passed"
    else
        echo "Test 1 failed: Expected '$expected1', but got '$output1'"
    fi

    if [[ "$output2" == "$expected2" ]]; then
        echo "Test 2 passed"
    else
        echo "Test 2 failed: Expected '$expected2', but got '$output2'"
    fi

    if [[ "$output3" == "$expected3" ]]; then
        echo "Test 3 passed"
    else
        echo "Test 3 failed: Expected '$expected3', but got '$output3'"
    fi
}

# TODO: Refactor this test to follow unit testing principles
library_test_function_replace_json_values() {
    echo "Running test test_replace_json_values..."

    # Example usage of the function
# replace_json_values template.json output.json name=Daniel age=30 city=SanFrancisco occupation=Developer

    local json_template="$DIR/files/json/example.json"
    local json_output="$DIR/files/json/example-output.json"
    local params="name=Daniel age=40 city=New York occupation=Engineer"
    local result=$(replace_json_values $json_template $json_output $params)
    echo "Result: $result"
}

library_test_function_replace_string_values_example() {
    echo "Testing replace_string_values_example..."
    local json_string='{"name": "{{name}}", "age": {{age}}}'
    local -A params=( ["name"]="John Doe" ["age"]=30 )

    local result=$(replace_string_values_example "$json_string" params)
    echo "Result: $result"
}



library_test_function_fetch_user_params() {
    echo "Testing fetch_user_params..."

    # Define test cases
    local input1="--id 123 --json input.json --profile user1 doesnotexist"
    local expected1="--id 123 --json input.json --profile user1"

    local input2="unknownparam --name Daniel --age 30 --city Tokyo "
    local expected2="--name Daniel --age 30 --city Tokyo"

    local input3="--option value --flag --another 42 unsupportedflag"
    local expected3="--option value --flag true --another 42"

    # Capture function output
    capture_output() {
        output=$(fetch_user_params $1)
        echo "$output"
    }

    # Run function and capture output
    local output1=$(capture_output "$input1")
    local output2=$(capture_output "$input2")
    local output3=$(capture_output "$input3")

    # Validate results
    if [[ "$output1" == "$expected1" ]]; then
        echo "Test 1 passed"
    else
        echo "Test 1 failed: Expected '$expected1', but got '$output1'"
    fi

    if [[ "$output2" == "$expected2" ]]; then
        echo "Test 2 passed"
    else
        echo "Test 2 failed: Expected '$expected2', but got '$output2'"
    fi

    if [[ "$output3" == "$expected3" ]]; then
        echo "Test 3 passed"
    else
        echo "Test 3 failed: Expected '$expected3', but got '$output3'"
    fi
}

debug_library_test_function_filter_params() {
    # Simulated user input (space-separated format)
    user_params="--explicit-run true --json input.json --id 123 --otheroption other.json --verbose --dry-run false"

    # Required & optional parameters (Boolean flags explicitly marked)
    required_params="i=id j=json"
    optional_params="p=profile o=otheroption verbose=boolean dry-run=boolean explicit-run=boolean"

    # Call function
    filtered_output=$(filter_params "$user_params" "$required_params" "$optional_params")

    # Display results
    echo "Filtered Parameters: $filtered_output"
}
  


library_test_function_filter_params() {
    echo "Running filter_params unit tests..."

    # Define test cases
    local test_cases=(
        "--json input.json --id 123 --otheroption other.json --verbose --dry-run false|i=id j=json|p=profile o=otheroption verbose=boolean dry-run=boolean|--json input.json --id 123 --otheroption other.json --verbose"
        "--json input.json --id 123 --otheroption other.json --verbose --dry-run|i=id j=json|p=profile o=otheroption verbose=boolean dry-run=boolean|--json input.json --id 123 --otheroption other.json --verbose --dry-run"
        "-j input.json -i 123 -o other.json --verbose --dry-run|i=id j=json|p=profile o=otheroption verbose=boolean dry-run=boolean|--json input.json --id 123 --otheroption other.json --verbose --dry-run"
        "-j input.json -i 123 -o other.json --verbose --dry-run false|i=id j=json|p=profile o=otheroption verbose=boolean dry-run=boolean|--json input.json --id 123 --otheroption other.json --verbose"
    )

    # Run each test case
    for test in "${test_cases[@]}"; do
        IFS="|" read -r user_params required_params optional_params expected_output <<< "$test"

        # Run function and capture output
        local actual_output
        actual_output=$(filter_params "$user_params" "$required_params" "$optional_params")

        # Validate results
        if [[ "$actual_output" == "$expected_output" ]]; then
            echo "✅ Test Passed: $user_params"
        else
            echo "❌ Test Failed: Expected '$expected_output', but got '$actual_output'"
        fi
    done
}







library_test_function_print_params() {
    echo "Testing print_params..."

    # Define test cases with correct parameter format
    local -A test_params1=( ["--id"]="123" ["--json"]="input.json" ["--profile"]="user1" )
    local expected1="--json input.json --id 123 --profile user1"

    local -A test_params2=( ["-n"]="Daniel" ["--age"]="30" ["--city"]="Tokyo" )
    local expected2="--city Tokyo -n Daniel --age 30"

    local -A test_params3=( ["--option"]="value" ["--flag"]="true" ["--another"]="42" )
    local expected3="--option value --flag true --another 42"

    # Function to capture correct output
    capture_output() {
        local var_name=$1  # Get the variable name as a string
        output=$(print_params "$var_name")  # Pass the name, not the variable itself
        echo "$output"
    }

    # Run function and capture output
    local output1=$(capture_output test_params1)
    local output2=$(capture_output test_params2)
    local output3=$(capture_output test_params3)

    # Validate results
    if [[ "$output1" == "$expected1" ]]; then
        echo "Test 1 passed"
    else
        echo "Test 1 failed: Expected '$expected1', but got '$output1'"
    fi

    if [[ "$output2" == "$expected2" ]]; then
        echo "Test 2 passed"
    else
        echo "Test 2 failed: Expected '$expected2', but got '$output2'"
    fi

    if [[ "$output3" == "$expected3" ]]; then
        echo "Test 3 passed"
    else
        echo "Test 3 failed: Expected '$expected3', but got '$output3'"
    fi
}
