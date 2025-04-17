DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/functions.sh"
LIB_TEMPLATES_PATH="$DIR/templates/s3.json"
echo "AWS CLI Wrapper Functions loaded into memory."
create_s3_bucket() {
    # Default template file path
    local template_file="$LIB_TEMPLATES_PATH"
    local bucket_name=""
    
    # Extract parameters using your CLI library
    user_params=$(fetch_user_params "$@")
    valid_params=$(filter_params "$user_params" "n=bucket-name p=profile" "template-file=$template_file")

    # Ensure bucket name is provided
    bucket_name="${valid_params[--bucket-name]}"
    if [[ -z "$bucket_name" ]]; then
        echo "Error: Bucket name must be specified using '-n' or '--bucket-name'." >&2
        return 1
    fi

    # Use provided template file if specified
    if [[ -n "${valid_params[--template-file]}" ]]; then
        template_file="${valid_params[--template-file]}"
    fi

    # Validate template file existence
    if [[ ! -f "$template_file" ]]; then
        echo "Error: JSON template file '$template_file' not found." >&2
        return 1
    fi

    # Generate final JSON input
    resolved_json=$(replace_json_values "$template_file" BucketName="$bucket_name")

    # Execute AWS CLI command
    aws s3api create-bucket --cli-input-json "$resolved_json" && \
    echo "S3 bucket '$bucket_name' created successfully!" || \
    echo "Error: Failed to create S3 bucket '$bucket_name'." >&2
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
