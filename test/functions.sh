#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Test functions for the library
# This file contains test functions for the library methods.
# These functions are used to test the functionality of the library methods
# and ensure that they work as expected.
# They are not meant to be run directly, but rather called from the main script.

test_replace_json_values() {
    echo "Running test test_replace_json_values..."

    # Example usage of the function
# replace_json_values template.json output.json name=Daniel age=30 city=SanFrancisco occupation=Developer

    local json_template="$DIR/files/json/example.json"
    local json_output="$DIR/files/json/example-output.json"
    local params="name=Daniel age=40 city=New York occupation=Engineer"
    local result=$(replace_json_values $json_template $json_output $params)
    echo "Result: $result"
}

test_replace_string_values_example() {
    echo "Testing replace_string_values_example..."
    local json_string='{"name": "{{name}}", "age": {{age}}}'
    local -A params=( ["name"]="John Doe" ["age"]=30 )

    local result=$(replace_string_values_example "$json_string" params)
    echo "Result: $result"
}

library_test_filter_params() {
    echo "Library method filter_params..."  # Debugging statement
    local -A required_params=( ["i"]="id" ["j"]="json" ["r"]="required" ) # map of required parameters
    local -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters
    local -A user_params
    local -A filtered_params

    local -S 

    filtered_params=$(filter_params $(fetch_user_paramsV2 "$@") required_params optional_params)

    echo "Required params:"
    echo "${filtered_params[@]}"
}

# library_test_copy() {
#     echo "Library method filter_params..."  # Debugging statement
#     local -A required_params=( ["i"]="id" ["j"]="json" ["r"]="required" ) # map of required parameters
#     local -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters
#     local -A user_params
#     local -A filtered_params

#     filtered_params=$(filter_params $(fetch_user_paramsV2 "$@") required_params optional_params)

#     echo "Required params:"
#     echo "${filtered_params[@]}"
# }

library_test_fetch_user_paramsV2 () {
    echo "Testing fetch_user_paramsV2..."
    fetch_user_paramsV2 "$@"
}


library_test_method_fetch_user_params() {
    echo "Testing library_test_method_fetch_user_params..."
    fetch_user_params "$@"
}


library_test_methods_fetch_user_params_and_filter_params() {

    local -A required_params=( ["i"]="id" ["j"]="json" ) # map of required parameters
    local -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters

    local user_params=$(fetch_user_params "$@")
    # user_params is a string of key-value pairs 
    # e.g. "id=123 json=input.json profile=default other-option=other.json"

    filter_params required_params optional_params user_params
    # business_logic1 filtered_params
}

library_test_methods_fetch_user_params_and_serialize_user_params() {

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