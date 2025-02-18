fetch_user_params() {
    declare -n params=$1
    while [[ "$2" != "" ]]; do
        if [[ "$2" == --* ]]; then
            key="${2:2}"
            shift
            params["$key"]=$2
        else
            # Continue silently for unknown parameters
            shift
            continue
        fi
        shift
    done
}

filter_params() {
    declare -A required_params=$1
    declare -A optional_params=$2
    declare -A user_params=$3
    declare -A matched_params=$4

    for key in "${!required_params[@]}"; do
        if [[ -n "${user_params[${required_params[$key]}]}" ]]; then
            matched_params["$key"]="${user_params[${required_params[$key]}]}"
        elif [[ -n "${user_params[$key]}" ]]; then
            matched_params["$key"]="${user_params[$key]}"
        fi
    done
}

library_method1() {
    declare -A required_params=( ["i"]="id" ["j"]="json" ["r"]="required" ) # map of required parameters
    declare -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters
    declare -A user_params
    declare -A filtered_params

    fetch_user_params user_params "$@"

    filter_params required_params optional_params user_params filtered_params

    echo "Required params:"
    echo "${filtered_params[@]}"
}
