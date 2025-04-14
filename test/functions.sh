#!/bin/bash



# Test functions for the library
# This file contains test functions for the library methods.
# These functions are used to test the functionality of the library methods
# and ensure that they work as expected.
# They are not meant to be run directly, but rather called from the main script.

test_replace_json_template_values() {
    echo "Testing replace_json_template_values..."
    local json_template="$DIR/files/json/example.json"
    replace_json_values $json_template name=Daniel age=40 city=NewYork occupation=Engineer
    # replace_json_values ./files/json/example.json name=Michael age=42 city=SanFrancisco occupation=Developer

    # Example usage of the function v01
    replace_json_values ./files/json/example.json name=Michael age=42
}

test_replace_json_template_values() {
    echo "Testing replace_json_template_values..."
    local json_string='{"name": "{{name}}", "age": {{age}}}'
    local -A params=( ["name"]="John Doe" ["age"]=30 )

    local result=$(replace_json_template_values "$json_string" params)
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


