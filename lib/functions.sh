# Define the function with named parameters
app_call_api() {
    declare -A params=() # Initialize an associative array
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -u|--url) params[url]="$2"; shift ;;
            -i|--id) params[id]="$2"; shift ;;
            -p|--profile) params[profile]="$2"; shift ;;
            *) echo "Unknown parameter passed: $1"; exit 1 ;;
        esac
        shift
    done

    # Access the named parameters
    local url="${params[url]}"
    local id="${params[id]}"
    local profile="${params[profile]}"

    echo "Calling API at $url with ID $id"
    # Check if profile is set and display it
    if [ -n "$profile" ]; then
        echo "Using profile $profile"
    fi
    # Your API call logic here
}
