#!/bin/bash

# Load the functions library
source ./test/load.sh

# Run the test function
# library_test_function_serialize_user_params # WORKING
# library_test_function_print_params          # WORKING
# library_test_function_fetch_user_params     # WORKING
# library_test_function_filter_params         # WORKING
# library_test_replace_json_values

# bats test_create_s3_bucket.bats
library_function_test_get_optional_param
library_function_test_get_required_param