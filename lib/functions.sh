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

    # Output array to be used in other functions
    print_params params
}

filter_params() {
    local -A user_params=$1
    local -A required_params=$2
    local -A optional_params=$3
    local -A matched_params

    # Check for single dash (-*) or double dash (--*) parameters
    # handling both short-form (-*) and long-form (--*) dash-based parameters.
    for key in "${!required_params[@]}"; do
        if [[ -n "${user_params[--${required_params[$key]}]}" ]]; then
            matched_params["--${required_params[$key]}"]="${user_params[--${required_params[$key]}]}"
        fi

        if [[ -n "${user_params[-$key]}" ]]; then
            matched_params["-$key"]="${user_params[-$key]}"
        fi
    done

    # TODO: Replace print_params with a function that formats the output as needed
    # For now, just print the matched parameters
    # print_params matched_params

    # Iterate through the array and format key-value pairs in a single line
    for key in "${!matched_params[@]}"; do
        echo -n "$key ${matched_params[$key]} "
    done
}

filter_params_v0_2() {
    local -A user_params=$1
    local -A required_params=$2
    local -A optional_params=$3
    local -A matched_params

    # Check for single dash (-*) or double dash (--*) parameters
    # handling both short-form (-*) and long-form (--*) dash-based parameters.
    for key in "${!required_params[@]}"; do
        if [[ -n "${user_params[--${required_params[$key]}]}" ]]; then
            matched_params["--${required_params[$key]}"]="${user_params[--${required_params[$key]}]}"
        fi

        if [[ -n "${user_params[-$key]}" ]]; then
            matched_params["-$key"]="${user_params[-$key]}"
        fi
    done

    print_params matched_params
}

serialize_user_params() {
    local -A params
    local result=""

    while [[ "$1" != "" ]]; do
        if [[ "$1" == --* || "$1" == -* ]]; then
            params["$1"]="$2"
            shift 2
        else
            shift
            continue
        fi
    done

    # Sort keys and properly strip hyphens before formatting output
    for key in $(printf "%s\n" "${!params[@]}" | sort); do
        clean_key="${key#--}"
        clean_key="${clean_key#-}"
        result+="${clean_key}=${params[$key]} "
    done

    echo "$result"
}

serialize_user_params__bug_has_dashes() {
    local -A params 
    local result=""

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
    
    # Convert associative array into space-separated key=value pairs
    for key in "${!params[@]}"; do
        result+="${key#-}=${params[$key]} "
    done

    echo "$result"
}

serialize_user_params_v0_1() {
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
    
    echo "${params[@]}"
}

replace_string_values_example() {
    local json_string="$1"
    local -A params=$2

    # Iterate through the associative array and replace placeholders in the JSON string
    for key in "${!params[@]}"; do
        json_string="${json_string//\{$key\}/${params[$key]}}"
    done

    echo "$json_string"
}

# Function to replace placeholders in a JSON template and output the result directly
replace_json_values() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: replace_json_values <input_json_template> <key1=value1> [key2=value2] ..."
        return 1
    fi

    local input_template=$1

    # Read template content
    local json_content
    json_content=$(<"$input_template")

    # Process key-value replacements
    shift
    for pair in "$@"; do
        local key=$(echo "$pair" | cut -d'=' -f1)
        local value=$(echo "$pair" | cut -d'=' -f2)

        # Replace placeholders in JSON content
        json_content=$(echo "$json_content" | sed "s|{{${key}}}|${value}|g")
    done

    # Output modified JSON
    echo "$json_content"
}


