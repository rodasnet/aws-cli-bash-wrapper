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

# Run the test function
# library_test_function_serialize_user_params # WORKING
# library_test_function_fetch_user_params     # NOT WORKING
# library_test_function_filter_params         # NOT WORKING

# Run the test function
library_test_function_print_params