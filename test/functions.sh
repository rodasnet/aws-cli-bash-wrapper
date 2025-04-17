#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Test functions for the library
# This file contains test functions for the library methods.
# These functions are used to test the functionality of the library methods
# and ensure that they work as expected.
# They are not meant to be run directly, but rather called from the main script.


library_test_function_serialize_user_params() {
    echo "Testing serialize_user_params..."

    # Define test cases
    local input1="--id 123 --json input.json --profile user1"
    local expected1="id=123 json=input.json profile=user1"

    local input2="--name Daniel --age 30 --city Tokyo"
    local expected2="name=Daniel age=30 city=Tokyo"

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

library_test_function_filter_params_v0_3_copilot() {
    
    local -A required_params=( ["i"]="id" ["j"]="json" ["r"]="required" ) # map of required parameters
    local -A optional_params=( ["p"]="profile" ["o"]="otheroption" ) # map of optional parameters
    local -A filtered_params
    local user_params="--json input.json --id 123 --other-option other.json"

    # Function to filter parameters
    filter_params() {
        local -A required=$1
        local -A optional=$2
        local params=$3
        declare -A output

        for param in ${params}; do
            key=${param%% *}
            value=${param#* }

            if [[ -v required[$key] ]]; then
                output[${required[$key]}]=$value
            elif [[ -v optional[$key] ]]; then
                output[${optional[$key]}]=$value
            fi
        done

        echo "${output[@]}"
    }

    # Example usage of the filter_params function
    filtered_params=$(filter_params required_params optional_params "$user_params")

    echo "Filtered Required params:"
    echo "${filtered_params[@]}"
}

library_test_function_filter_params() {

    local -A required_params=( ["i"]="id" ["j"]="json" ["r"]="required" ) # map of required parameters
    local -A optional_params=( ["p"]="profile" ["o"]="otheroption" ) # map of optional parameters
    local user_params="--json input.json --id 123 --otheroption other.json"
    local -A filtered_params

    # example usage of thefilter_params function
    filter_params "$user_params" required_params optional_params

    echo "Required params:"
    echo "${filtered_params[@]}"
}

library_test_function_fetch_user_paramsV2 () {
    echo "Testing fetch_user_paramsV2..."
    fetch_user_paramsV2 "$@"
}


library_test_function_fetch_user_params() {
    echo "Testing library_test_method_fetch_user_params..."
    fetch_user_params "$@"
}


library_test_function_fetch_user_params_and_filter_params() {

    local -A required_params=( ["i"]="id" ["j"]="json" ) # map of required parameters
    local -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters

    local user_params=$(fetch_user_params "$@")
    # user_params is a string of key-value pairs 
    # e.g. "id=123 json=input.json profile=default other-option=other.json"

    filter_params required_params optional_params user_params
    # business_logic1 filtered_params
}

library_test_function_fetch_user_params_and_serialize_user_params() {

    local user_params=$(fetch_user_params "$@")
    # user_params is a string of key-value pairs 
    # e.g. "id=123 json=input.json profile=default other-option=other.json"

    serialize_user_params "$user_params"
}

# library_test_methods_fetch_user_params_and_filter_params() {

#     declare -A required_params=( ["i"]="id" ["j"]="json" ) # map of required parameters
#     declare -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters

#     fetch_user_params "$@" 
#     filter_params required_params optional_params user_params
#     business_logic1 filtered_params
# }

business_logic1() { echo "Business logic 1 executed with params: $@"; }