#!/bin/bash

print_keys() {
    # Convert the input arguments to associative arrays
    declare -n array1=$1
    declare -n array2=$2

    echo "Array 1:"
    for key in "${!array1[@]}"; do
        echo $key
    done

    echo "Array 2:"
    for key in "${!array2[@]}"; do
        echo $key
    done
}

declare -A array1=( ["a"]="apple" ["b"]="boy" )
declare -A array2=( ["z"]="zeebra" ["x"]="xero" )

print_keys array1 array2


# Function to print key-value pairs from two associative arrays
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

declare -A array3=( ["a"]="apple" ["b"]="boy" )
declare -A array4=( ["z"]="zeebra" ["x"]="xero" )

print_keys_and_values array31 array4
