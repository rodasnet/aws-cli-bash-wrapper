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

serialize_user_params() {
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

    print_params matched_params
}

# filter_params() {
#     local -A user_params=$1
#     local -A required_params=$2
#     local -A optional_params=$3
#     local -A matched_params

#     # Check for single dash (-*) or double dash (--*) parameters
#     # handling both short-form (-*) and long-form (--*) dash-based parameters.
#     for key in "${!required_params[@]}"; do
#         if [[ -n "${user_params[--${required_params[$key]}]}" ]]; then
#             matched_params["--${required_params[$key]}"]="${user_params[--${required_params[$key]}]}"
#         fi

#         if [[ -n "${user_params[-$key]}" ]]; then
#             matched_params["-$key"]="${user_params[-$key]}"
#         fi
#     done

#     print_params matched_params
# }

library_test_filter_params() {
    echo "Library method filter_params..."  # Debugging statement
    local -A required_params=( ["i"]="id" ["j"]="json" ["r"]="required" ) # map of required parameters
    local -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters
    local -A user_params
    local -A filtered_params

    local -S 

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


replace_string_values_example() {
    local json_string="$1"
    local -A params=$2

    # Iterate through the associative array and replace placeholders in the JSON string
    for key in "${!params[@]}"; do
        json_string="${json_string//\{$key\}/${params[$key]}}"
    done

    echo "$json_string"
}

# Function to replace placeholders in a JSON template
replace_json_values() {
    # Check if at least two arguments are provided
    if [ "$#" -lt 2 ]; then
        echo "Usage: replace_json_values <input_json_template> <key1=value1> [key2=value2] ..."
        return 1
    fi

    # Assign the input JSON template to a variable
    local input_template=$1

    # Create output JSON file
    local output_file="output.json"
    cp "$input_template" "$output_file"

    # Iterate through key-value pairs
    shift # Move past the first argument (input_template)
    for pair in "$@"; do
        local key=$(echo "$pair" | cut -d'=' -f1)
        local value=$(echo "$pair" | cut -d'=' -f2)
        
        # Replace placeholders with actual values in the JSON file
        sed -i "s|{{${key}}}|${value}|g" "$output_file"
    done

    echo "The JSON file has been updated and saved as $output_file"
    return 0
}

