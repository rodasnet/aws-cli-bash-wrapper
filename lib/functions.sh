invoke_cli_command() {
    local command="$1"

    local params="$2"

    # Check if the command is valid
    if [[ -z "$command" ]]; then
        echo "Error: No command provided." >&2
        return 1
    fi

    # Execute the command with parameters
    # eval "$command $params"
    echo "$command $params"
}

get_param_value() {
    local param_name="$1"
    local kvpair=""
    
    kvpair=$(get_kv_pair "$param_name")

    # Extract only the value assuming the format "--key value"
    echo "${kvpair#* }"
}

get_param_value_or_default() {
    local param_name="$1"
    local default_value="$2"

    # Check if the parameter is set in the valid_params
    local kvpair=$(get_kv_pair "$param_name")

    if [[ -z "$kvpair" ]]; then
        echo "$default_value"
    else
        # Extract only the value assuming the format "--key value"
        echo "${kvpair#* }"
    fi
}

get_kv_pair() {
    local param_name="$1"

    filtered_output=$(filter_params "$valid_params" "$param_name" "")

    echo "$filtered_output"
}

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

filter_params() {
    local user_params="$1"  # User input as space-separated key-value pairs
    local required_params="$2"  # Expected format: "i=id j=json"
    local optional_params="$3"  # Expected format: "p=profile o=otheroption verbose=boolean dry-run=boolean"

    local -A matched_params
    local key value
    local boolean_flags=()
    
    # Expand short-form parameters into their long-form equivalents
    for entry in $required_params $optional_params; do
        key="${entry%%=*}"   # Extract short-name key (e.g., "j")
        value="${entry#*=}"   # Extract corresponding full parameter name (e.g., "json" or "boolean")

        if [[ "$value" == "boolean" ]]; then
            # Handle Boolean flags, ensuring only double-dash flags are allowed
            if [[ "$user_params" == *"--$key "* ]]; then
                bool_value="${user_params##*--$key }"
                bool_value="${bool_value%% *}"  # Extract potential Boolean value

                # If "--dry-run false" is provided, omit it entirely
                if [[ "$key" == "dry-run" && "$bool_value" == "false" ]]; then
                    continue
                fi

                boolean_flags+=("--$key")  # Default to true if flag is present without a value
            elif [[ "$user_params" == *"--$key"* ]]; then
                boolean_flags+=("--$key")
            fi
        else
            # Handle both long-form (--json) and short-form (-j) parameters correctly
            if [[ "$user_params" == *"--$value "* ]]; then
                matched_params["--$value"]="${user_params##*--$value }"
                matched_params["--$value"]="${matched_params["--$value"]%% *}"  # Extract correct value
            elif [[ "$user_params" == *"-$key "* ]]; then
                matched_params["--$value"]="${user_params##*-$key }"
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
