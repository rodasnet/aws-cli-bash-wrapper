DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/functions.sh"
LIB_TEMPLATES_PATH="$DIR/templates/"
echo "AWS CLI Wrapper Functions loaded into memory."

declare -A valid_params

grant-lf-permission-readonly() {

    # Default template file path
    local template_path="$LIB_TEMPLATES_PATH"
    local template_file="lakeformation/permission-readonly.json"

    # Extract parameters using your CLI library
    user_params=$(fetch_user_params "$@")
    valid_params=$(filter_params "$user_params" "p=principal c=catalog-id" "p=profile r=region")

    # Global CLI parameters
    profile_selection=$(get_kv_pair "p=profile")
    region=$(get_param_value_or_default "r=region" "us-west-1")

    # Example boolean parameter
    # dry_run=$(get_kv_pair "dry-run=boolean")

    # Command specific parameters
    catalog_id=$(get_param_value "c=catalog-id")
    principal=$(get_param_value "p=principal")

    # Bind parameters to JSON template    
    json_config=$(replace_json_values "${template_path}${template_file}" CatalogId="$catalog_id" Principal="$principal" Region="$region")

    # Invoke the AWS CLI command with the JSON config
    invoke_cli_command "aws lakeformation grant-permissions" "--cli-input-json '$json_config' $profile_selection"
}

create-s3-bucket-using-internal-json() {

    # Default template file path
    local template_path="$LIB_TEMPLATES_PATH"
    local template_file="s3.json"
    
    # Extract parameters using your CLI library
    user_params=$(fetch_user_params "$@")
    valid_params=$(filter_params "$user_params" "n=name p=profile" "r=region t=template-file dry-run=boolean")

    bucket_name=$(get_param_value "n=name")
    profile_selection=$(get_kv_pair "p=profile")
    region=$(get_param_value_or_default "r=region" "us-west-1")
    dry_run=$(get_kv_pair "dry-run=boolean")

    json_config=$(replace_json_values "${template_path}${template_file}" BucketName="$bucket_name" Region="$region")
    invoke_cli_command "aws s3api create-bucket" "--cli-input-json '$json_config' $profile_selection"
}

create-s3-bucket() {

    local template_file="$LIB_TEMPLATES_PATH"
    local bucket_name=""
    
    # Extract parameters using your CLI library
    user_params=$(fetch_user_params "$@")
    valid_params=$(filter_params "$user_params" "n=name p=profile" "r=region t=template-file dry-run=boolean")

    bucket_name=$(get_param_value "n=name")
    profile_selection=$(get_kv_pair "p=profile")
    template_file=$(get_kv_pair "t=template-file")
    region=$(get_kv_pair "r=region")
    dry_run=$(get_kv_pair "dry-run=boolean")

    invoke_cli_command "aws s3api create-bucket" "--bucket $bucket_name $template_file $dry_run $region $profile_selection"
}

create-s3-bucket_v0_1() {

    local template_file="$LIB_TEMPLATES_PATH"
    local bucket_name=""
    
    # Extract parameters using your CLI library
    user_params=$(fetch_user_params "$@")
    valid_params=$(filter_params "$user_params" "n=name p=profile" "r=region t=template-file dry-run=boolean")

    bucket_name=$(get_param_value "n=name")
    profile_selection=$(get_kv_pair "p=profile")
    template_file=$(get_kv_pair "t=template-file")
    region=$(get_kv_pair "r=region")
    dry_run=$(get_kv_pair "dry-run=boolean")

    invoke_cli_command "aws s3api create-bucket" "--bucket $bucket_name $template_file $dry_run $region $profile_selection"
}

create_s3_bucket_simple() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: create_s3_bucket <template_file> <BucketName>"
        return 1
    fi

    local template_file=$1
    local bucket_name=$2

    aws s3api create-bucket --cli-input-json "$(replace_json_values "$template_file" BucketName="$bucket_name")"

    echo "S3 bucket '$bucket_name' created successfully!"
    return 0
}

# Function to launch an EC2 instance without writing to disk
launch_ec2_instance() {

    # Example usage
    # launch_ec2_instance my-template.json ami-1234567890abcdef0
    if [ "$#" -lt 2 ]; then
        echo "Usage: launch_ec2_instance <template_file> <ImageId>"
        return 1
    fi

    local template_file=$1
    local image_id=$2

    # Pass dynamically replaced JSON directly to AWS CLI
    aws ec2 run-instances --cli-input-json "$(replace_json_values "$template_file" ImageId="$image_id")"

    echo "EC2 instance launched using Image ID: $image_id"
    return 0
}

copilotgen_lake_formation_grant_permissions() {
  local bucket_name=$1
  local account_id=$2
  local region=$3

  if [ -z "$bucket_name" ] || [ -z "$account_id" ] || [ -z "$region" ]; then
    echo "Usage: lf_grant_permissions <bucket_name> <account_id> <region>"
    return 1
  fi

  aws s3api put-bucket-acl --bucket "$bucket_name" --grant-read "uri=http://acs.amazonaws.com/groups/global/AllUsers" --region "$region"
  aws s3api put-bucket-policy --bucket "$bucket_name" --policy "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
      {
        \"Effect\": \"Allow\",
        \"Principal\": {
          \"AWS\": \"arn:aws:iam::$account_id:root\"
        },
        \"Action\": \"s3:GetObject\",
        \"Resource\": \"arn:aws:s3:::$bucket_name/*\"
      }
    ]
  }" --region "$region"
}
