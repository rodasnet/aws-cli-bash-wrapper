library_method1() {

    declare -A required_params=( ["i"]="id" ["j"]="json" ) # map of required parameters
    declare -A optional_params=( ["p"]="profile" ["o"]="other-option" ) # map of optional parameters

    fetch_user_params 
    filter_params required_params optional_params user_params
    business_logic1 filtered_params
}

library_method2() {

    declare -A required_params=( ["n"]="name" ["j"]="json" ) # map of required parameters
    declare -A optional_params=( ["p"]="profile" ["a"]="alternate-option" ) # map of optional parameters

    fetch_user_params 
    filter_params required_params optional_params user_params
    business_logic1 filtered_params
}


fetch_user_params() {}


filter_params() {
    declare -n required_params=$1
    declare -n optional_params=$2
    declare -A user_params=$3

}

business_logic1() {}

library_method1 --json input.json --id 123 --other-option other.json
library_method2 --json input.json --name jane --alternet-option other.json