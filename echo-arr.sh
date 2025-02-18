#!/bin/bash

# print_keys() {
#     # Convert the input arguments to associative arrays
#     declare -n array1=$1
#     declare -n array2=$2

#     echo "Array 1:"
#     for key in "${!array1[@]}"; do
#         echo $key
#     done

#     echo "Array 2:"
#     for key in "${!array2[@]}"; do
#         echo $key
#     done
# }

# declare -A array1=( ["a"]="apple" ["b"]="boy" )
# declare -A array2=( ["z"]="zeebra" ["x"]="xero" )

# print_keys array1 array2


# Function to print key-value pairs from two associative arrays
# print_keys_and_values() {
#     declare -n array1=$1
#     declare -n array2=$2

#     echo "Array 1:"
#     for key in "${!array1[@]}"; do
#         echo "$key: ${array1[$key]}"
#     done

#     echo "Array 2:"
#     for key in "${!array2[@]}"; do
#         echo "$key: ${array2[$key]}"
#     done
# }

# declare -A array3=( ["a"]="apple" ["b"]="boy" )
# declare -A array4=( ["z"]="zeebra" ["x"]="xero" )

# print_keys_and_values array3 array4


#!/bin/bash

# Function to print key-value pairs from two associative arrays and test keys
# print_keys_and_valuesv2() {
#     declare -n array1=$1
#     declare -n array2=$2

#     echo "While Array 1:"
#     for key in "${!array1[@]}"; do
#         case $key in
#             "$key")
#                 echo "$key: ${array1[$key]}"
#                 ;;
#             *)
#                 echo "$key: ${array1[$key]} - Key is something else"
#                 ;;
#         esac
#     done

#     echo "While Array 2:"
#     for key in "${!array2[@]}"; do
#         case $key in
#             "$key")
#                 echo "$key: ${array2[$key]}"
#                 ;;
#             *)
#                 echo "$key: ${array2[$key]} - Key is something else"
#                 ;;
#         esac
#     done
# }

# declare -A array5=( ["a"]="apple" ["b"]="boy" )
# declare -A array6=( ["z"]="zeebra" ["x"]="xero" )

# print_keys_and_valuesv2 array5 array6


# Function to print key-value pairs from two associative arrays
print_keys_and_valuesv3() {
    declare -n array1=$1
    declare -n array2=$2
    declare -A params=()

    echo "Array 1:"
    for key in "${!array1[@]}"; do
        echo "$key: ${array1[$key]}"
    done

    echo "Array 2:"
    for key in "${!array2[@]}"; do
        echo "$key: ${array2[$key]}"
    done
}


call_func_v3() {
    declare -A array7=( ["a"]="apple" ["b"]="boy" )
    declare -A array8=( ["z"]="zeebra" ["x"]="xero" )

    print_keys_and_valuesv3 array7 array8
}

call_func_v4() {
    declare -A array7=( ["a"]="apple" ["b"]="boy" )
    declare -A array8=( ["z"]="zeebra" ["x"]="xero" )

    print_keys_and_valuesv3 array7 array8
}

get_uops() {


    while getopts ":u:" opt; do
    case ${opt} in
        u ) 
        url=$OPTARG
        echo "URL: $url"
        ;;
        \? )
        echo "Invalid option: -$OPTARG" 1>&2
        ;;
        : )
        echo "Option -$OPTARG requires an argument" 1>&2
        ;;
    esac
    done
    shift $((OPTIND -1))

    # Example of using the $url variable
    if [ -n "$url" ]; then
        echo "The URL provided is: $url"
    else
        echo "No URL provided"
    fi

}