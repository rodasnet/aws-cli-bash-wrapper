print_params() {
    local -n params_ref=$1
    # Iterate through the array and format key-value pairs in a single line
    for key in "${!params_ref[@]}"; do
        echo -n "$key ${params_ref[$key]} "
    done
}

fetch_user_params() {
    local -A params  
    while [[ "$1" != "" ]]; do
        if [[ "$1" == --* || "$1" == -* ]]; then
            params["$1"]=$2
            shift 2
        else
            # Continue silently for unknown parameters
            shift
            continue
        fi
    done

    print_params params
}

filter_params() {
    local -A user_params=$1
    local -A required_params=$2
    local -A optional_params=$3
    local -A matched_params

    # TODO: Add a check for single dash (-*) or double dash (--*) parameters
    for key in "${!required_params[@]}"; do
        if [[ -n "${user_params[${required_params[$key]}]}" ]]; then
            matched_params["$key"]="${user_params[${required_params[$key]}]}"
        elif [[ -n "${user_params[$key]}" ]]; then
            matched_params["$key"]="${user_params[$key]}"
        fi
    done

    print_params matched_params
}

library_test_filter_params() {
    echo "Library method filter_params..."  # Debugging statement
    local -A required_params=( ["i"]="id" ["j"]="json" ["r"]="required" ) # map of required parameters
    local -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters
    local -A user_params
    local -A filtered_params

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
