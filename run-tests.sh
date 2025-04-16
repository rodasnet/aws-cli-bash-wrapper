#!/bin/bash

# Load the functions library
source ./test/load.sh

test_replace_json_values

library_test_method_fetch_user_params --json input.json --id 123 --other-option other.json
echo ""
echo "----------------------------------------"
echo ""

# library_test_methods_fetch_user_params_and_filter_params --json input.json --id 123 --other-option other.json
library_test_methods_fetch_user_params_and_serialize_user_params --json input.json --id 123 --other-option other.json