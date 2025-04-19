
## Fetch user parameters

The library function `fetch_user_params` will return a string of the user parameters and there values for single and double as well as implicit boolean flag parameters for double dashed parameters without a value.
```bash

print-parameter-raw() {
    
    local raw_parameters=$(fetch_user_params "$@")

    echo "Printing raw user parameter: $raw_parameters"
}

```
### Output from printing raw parameters
```bash
$ print-parameter-raw --flag --other thing2
Printing raw user parameter: --flag true --other thing2
```
## parameter filter

The 
```bash

print-parameter-filter() {

    # Extract parameters using your CLI library
    user_params=$(fetch_user_params "$@")
    valid_params=$(filter_params "$user_params" "f=filtered")

    # Example boolean parameter
    # command --my-bool-flag (implicit true)
    filtered_output=$(get_kv_pair "f=filtered")

    echo "Printing all user parameter: $user_params"
    echo "Printing filtered parameter: $filtered_output"
}

```
### Output from printing filtered parameters
```bash
$ print-parameter-filter --fake-param --filtered my-filtered-value --unauthorized yes
Printing all user parameter: --fake-param true --filtered my-filtered-value --unauthorized yes
Printing filtered parameter: --filtered my-filtered-value
```