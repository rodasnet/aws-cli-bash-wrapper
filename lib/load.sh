# Define the function with named parameters
app_call_api() {
    declare -A params=() # Initialize an associative array
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -u|--url) params[url]="$2"; shift ;;
            -i|--id) params[id]="$2"; shift ;;
            *) echo "Unknown parameter passed: $1"; exit 1 ;;
        esac
        shift
    done

    # Access the named parameters
    local url="${params[url]}"
    local id="${params[id]}"

    echo "Calling API at $url with ID $id"
    # Your API call logic here
}
rodas0@rn-wsw-mgmt-pc-01:~/shell/lib$ ls
domain1.sh  functions.sh  load.sh  v
rodas0@rn-wsw-mgmt-pc-01:~/shell/lib$ cat load.sh 
# load.sh
#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/functions.sh"
echo "Functions loaded into memory."