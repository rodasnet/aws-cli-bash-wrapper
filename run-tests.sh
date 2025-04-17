#!/bin/bash

# Load the functions library
source ./test/load.sh

# Run the test function
# library_test_function_serialize_user_params # WORKING
# library_test_function_print_params          # WORKING
library_test_function_fetch_user_params     # NOT WORKING
# library_test_function_filter_params         # NOT WORKING