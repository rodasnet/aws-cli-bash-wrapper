#!/bin/bash

# Load the functions library
source ./test/load.sh


# Test the library_test_function_fetch_user_params functions
# Example usage of the function
# library_test_function_fetch_user_params --json input.json --id 123 --other-option other.json
# 
# Expected output:
# --json input.json --id 123 --other-option other.json
# library_test_function_fetch_user_params --json input.json --id 123 --other-option other.json


# Test the library_test_function_filter_params function
# Example usage of the function
# library_test_function_filter_params
# 
# Expected output:
# --json input.json --id 123 --other-option other.json
# library_test_function_filter_params

# library_test_function_filter_params --json input.json --id 123 --other-option other.json
# # library_test_methods_fetch_user_params_and_filter_params --json input.json --id 123 --other-option other.json
# library_test_methods_fetch_user_params_and_serialize_user_params --json input.json --id 123 --other-option other.json
# test_replace_json_values

# Run the test function
library_test_function_serialize_user_params