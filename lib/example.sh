print_keys_and_values_and_inputs() {
    declare -n array1=$1
    declare -n array2=$2
    declare -n inputs=$3

    echo "Array 1:"
    for key in "${!array1[@]}"; do
        echo "$key: ${array1[$key]}"
    done

    echo "Array 2:"
    for key in "${!array2[@]}"; do
        echo "$key: ${array2[$key]}"
    done

    echo "Inputs:"
    for key in "${!inputs[@]}"; do
        echo "$key: ${inputs[$key]}"
    done
}

comopare_params() {
    declare -A required_params=( ["i"]="id" ["j"]="json" ) # map of required parameters
    declare -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters
    declare -A user_params=( ["j"]="input.json" ["i"]="user1" ) 
    declare -A matched_params

    for key in "${!required_params[@]}"; do
        if [[ -n "${user_params[${required_params[$key]}]}" ]]; then
            matched_params["$key"]="${user_params[${required_params[$key]}]}"
        elif [[ -n "${user_params[$key]}" ]]; then
            matched_params["$key"]="${user_params[$key]}"
        fi
    done

}

print_keys_and_values() {
    declare -n array1=$1
    declare -n array2=$2

    echo "Array 1:"
    for key in "${!array1[@]}"; do
        echo "$key: ${array1[$key]}"
    done

    echo "Array 2:"
    for key in "${!array2[@]}"; do
        echo "$key: ${array2[$key]}"
    done
}

# library_method2() {
#     declare -A required_params=( ["n"]="name" ["j"]="json" ) # map of required parameters
#     declare -A optional_params=( ["p"]="profile" ["a"]="alternate-option" ) # map of optional parameters

#     fetch_user_params "$@"
#     filter_params required_params optional_params user_params
#     business_logic1 filtered_params
# }


# do_something() {
#     declare -A required_params=( ["u"]="url" ["i"]="id" ["j"]="json" ) # map of required parameters
#     declare -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters

#     declare -A resulted_params=()
#     fetch_user_params "$@" resulted_params
#     filter_params required_params optional_params user_params

#     echo "Required params:"
#     for key in "${!required_params[@]}"; do
#         echo "$key: ${filtered_params[${required_params[$key]}]}"
#     done

#     echo "Optional params:"
#     for key in "${!optional_params[@]}"; do
#         echo "$key: ${filtered_params[${optional_params[$key]}]}"
#     done
# }