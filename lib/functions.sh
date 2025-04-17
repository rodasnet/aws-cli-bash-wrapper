print_params() {
    local -n params_ref=$1
    local result=""

    # Iterate through the array and format key-value pairs in a single line
    for key in "${!params_ref[@]}"; do
        result+="$key ${params_ref[$key]} "
    done

    # Trim trailing space before printing
    echo "${result% }"
}

fetch_user_params() {
    local -A params
    local ordered_keys=()

    while [[ "$1" != "" ]]; do
        if [[ "$1" == --* ]]; then  # Only allow boolean for double-dashed parameters
            clean_key="$1"

            if [[ -z "$2" || "$2" == --* || "$2" == -* ]]; then
                params["$clean_key"]="true"  # Assign "true" only to standalone double-dash flags
                ordered_keys+=("$clean_key")
                shift
            else
                params["$clean_key"]="$2"
                ordered_keys+=("$clean_key")
                shift 2
            fi
        elif [[ "$1" == -* ]]; then  # Single-dash parameters must have values
            clean_key="$1"

            if [[ -z "$2" || "$2" == --* || "$2" == -* ]]; then
                echo "Error: Single-dash parameter '$clean_key' must have a value." >&2
                return 1
            else
                params["$clean_key"]="$2"
                ordered_keys+=("$clean_key")
                shift 2
            fi
        else
            shift
            continue
        fi
    done

    # Print parameters in the original order
    local result=""
    for key in "${ordered_keys[@]}"; do
        result+="$key ${params[$key]} "
    done

    echo "${result% }"
}

fetch_user_params_v0_02() {
    local -A params
    local ordered_keys=()

    while [[ "$1" != "" ]]; do
        if [[ "$1" == --* || "$1" == -* ]]; then
            clean_key="$1"

            # Check if the next argument is missing or another flag
            if [[ -z "$2" || "$2" == --* || "$2" == -* ]]; then
                params["$clean_key"]="true"  # Assign "true" to standalone flags
                ordered_keys+=("$clean_key")
                shift
            else
                params["$clean_key"]="$2"
                ordered_keys+=("$clean_key")
                shift 2
            fi
        else
            shift
            continue
        fi
    done

    # Print parameters in the original order
    local result=""
    for key in "${ordered_keys[@]}"; do
        result+="$key ${params[$key]} "
    done

    echo "${result% }"
}

fetch_user_params_v0_01() {
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
    local user_params="$1"  # User input as space-separated key-value pairs
    local required_params="$2"  # Expected format: "i=id j=json"
    local optional_params="$3"  # Expected format: "p=profile o=otheroption verbose=boolean dry-run=boolean"

    local -A matched_params
    local key value
    local boolean_flags=()  # Store Boolean flags separately

    # Process required and optional parameters
    for entry in $required_params $optional_params; do
        key="${entry%%=*}"   # Extract short-name key (e.g., "p")
        value="${entry#*=}"   # Extract corresponding full parameter name (e.g., "profile" or "boolean")

        if [[ "$value" == "boolean" ]]; then
            # Ensure Boolean flags only use double-dash prefix
            if [[ "$user_params" == *"--$key"* ]]; then
                boolean_flags+=("--$key")
            fi
        else
            # Handle key-value pairs normally
            if [[ "$user_params" == *"--$value "* ]]; then
                matched_params["--$value"]="${user_params##*--$value }"
                matched_params["--$value"]="${matched_params["--$value"]%% *}"  # Extract correct value
            fi
        fi
    done

    # Convert associative array into space-separated key=value pairs
    local result=""
    for key in "${!matched_params[@]}"; do
        result+="$key ${matched_params[$key]} "
    done

    # Append Boolean flags at the end
    for flag in "${boolean_flags[@]}"; do
        result+="$flag "
    done

    # Trim trailing space before returning output
    echo "${result% }"
}

filter_params_v0_03() {
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
    # Convert associative array into space-separated key=value pairs
    serialize_user_params $(print_params matched_params)

}

serialize_user_params() {
    local -A params
    local processed_keys=()
    local result=""

    while [[ "$1" != "" ]]; do
        if [[ "$1" == --* || "$1" == -* ]]; then
            clean_key="${1#--}"
            clean_key="${clean_key#-}"

            if [[ "$2" == "" || "$2" == --* || "$2" == -* ]]; then
                params["$clean_key"]="true"  # Store lone flags as boolean true
                shift
            else
                params["$clean_key"]="$2"
                processed_keys+=("$clean_key")  # Preserve input order
                shift 2
            fi
        else
            shift
            continue
        fi
    done

    # Second pass: Assemble key-value pairs in original order
    for key in "${processed_keys[@]}"; do
        result+="${key}=${params[$key]} "
    done

    # Trim trailing space before output
    echo "${result% }"
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


# Older version of the function for backward compatibility
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
