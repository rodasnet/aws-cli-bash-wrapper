fetch_user_params() {
    local -A params  # Declare an associative array locally
    while (( "$#" )); do
        case "$1" in
            -i|--id)
                params["id"]="$2"
                shift 2
                ;;
            -j|--json)
                params["json"]="$2"
                shift 2
                ;;
            -r|--required)
                params["required"]="$2"
                shift 2
                ;;
            -p|--profile)
                params["profile"]="$2"
                shift 2
                ;;
            -o|--other-option)
                params["other-option"]="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
    echo $(declare -p params)
}

filter_params() {
    local -A user_params=$(eval "echo \${$1}")
    local -A required_params=$(eval "echo \${$2}")
    local -A optional_params=$(eval "echo \${$3}")
    local -A matched_params=()

    for key in "${!required_params[@]}"; do
        if [[ -v "user_params[$key]" ]]; then
            matched_params["${required_params[$key]}"]="${user_params[$key]}"
        fi
    done

    for key in "${!optional_params[@]}"; do
        if [[ -v "user_params[$key]" ]]; then
            matched_params["${optional_params[$key]}"]="${user_params[$key]}"
        fi
    done

    echo $(declare -p matched_params)
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
    echo $(declare -p filtered_params)
}
