fetch_user_params() {
    local -A params  
    while [[ "$1" != "" ]]; do
        if [[ "$1" == --* || "$1" == -* ]]; then
            params["$1"]=$2
            shift 2
        else
            shift
            continue
        fi
    done

    # Convert associative array into space-separated key=value pairs
    local result=""
    for key in "${!params[@]}"; do
        result+="${key#-}=${params[$key]} "
    done

    echo "$result"
}

filter_params() {
    local -A required_params=$1
    local -A optional_params=$2
    local -A matched_params
    local input_string="$3"

    # Convert key=value string into an associative array using Bash string parsing
    declare -A user_params
    for pair in $input_string; do
        key="${pair%%=*}"   # Extract key (everything before '=')
        value="${pair#*=}"   # Extract value (everything after '=')
        user_params["$key"]="$value"
    done

    # Filter out required parameters
    for key in "${!required_params[@]}"; do
        if [[ -n "${user_params[${required_params[$key]}]}" ]]; then
            matched_params["--${required_params[$key]}"]="${user_params[${required_params[$key]}]}"
        fi
    done

    print_params matched_params
}

print_params() {
    local -n params_ref=$1
    for key in "${!params_ref[@]}"; do
        echo -n "$key=${params_ref[$key]} "
    done
}

# Test invocation
library_test_methods_fetch_user_params_and_filter_params() {
    local -A required_params=( ["i"]="id" ["j"]="json" ) 
    local -A optional_params=( ["p"]="profile" ["o"]="other-option" )

    local user_params
    user_params=$(fetch_user_params "$@") # Gets key=value formatted string

    filter_params required_params optional_params "$user_params"
}

# Example test run
library_test_methods_fetch_user_params_and_filter_params --i 123 --j input.json --p default --o other.json