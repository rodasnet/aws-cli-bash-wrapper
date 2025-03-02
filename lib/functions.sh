fetch_user_params() {
    while [[ "$1" != "" ]]; do
        if [[ "$1" == --* ]]; then
            key="${1:2}"
            shift
            params["$key"]=$1
        else
            # Continue silently for unknown parameters
            shift
            continue
        fi
        shift
    done

    # Output the params array for use in another function
    echo "${params[@]}"
}

fetch_user_paramsV2() {
    local -A params  # Declare an associative array locally
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

    # Iterate through the array and format key-value pairs in a single line
    for key in "${!params[@]}"; do
        echo -n "$key ${params[$key]} "
    done
    # echo # Add a newline at the end
}

filter_params() {
    local -A user_params=$1
    echo "User params: ${user_params[@]}"  # Debugging statement
    local -A required_params=$2
    local -A optional_params=$3
    local -A matched_params

    for key in "${!required_params[@]}"; do
        if [[ -n "${user_params[${required_params[$key]}]}" ]]; then
            matched_params["$key"]="${user_params[${required_params[$key]}]}"
        elif [[ -n "${user_params[$key]}" ]]; then
            matched_params["$key"]="${user_params[$key]}"
        fi
    done

    echo "${matched_params[@]}"
}

library_method1() {
    echo "Library method 1..."  # Debugging statement
    local -A required_params=( ["i"]="id" ["j"]="json" ["r"]="required" ) # map of required parameters
    local -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters
    local -A user_params
    local -A filtered_params

    filtered_params=$(filter_params $(fetch_user_paramsV2 "$@") required_params optional_params)

    echo "Required params:"
    echo "${filtered_params[@]}"
}

library_test_fetch_user_paramsV2 () {
    echo "Testing fetch_user_paramsV2..."
    fetch_user_paramsV2 "$@"
}
