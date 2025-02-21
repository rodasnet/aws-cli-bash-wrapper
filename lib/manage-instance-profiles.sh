remove_role_from_instance_profile() {
    local role_name=$1

    aws iam list-instance-profiles-for-role --role-name $role_name --query 'InstanceProfiles[].InstanceProfileName' --output text | while read -r instance_profile; do
        aws iam remove-role-from-instance-profile --instance-profile-name $instance_profile --role-name $role_name
    done
}

delete_role_policies() {
    local role_name=$1

    aws iam list-role-policies --role-name $role_name --query 'PolicyNames' --output text | while read -r policy_name; do
        aws iam delete-role-policy --role-name $role_name --policy-name $policy_name
    done
}

detach_role_policies() {
    local role_name=$1

    aws iam list-attached-role-policies --role-name $role_name --query 'AttachedPolicies[].PolicyArn' --output text | tr '\t' '\n' | while read -r policy_arn; do
        aws iam detach-role-policy --role-name $role_name --policy-arn $policy_arn
    done
}

# delete_instance_profile() {
#     local instance_profile_name=$1
#     aws iam delete-instance-profile --instance-profile-name $instance_profile_name
# }

delete_role() {
    local role_name=$1
    aws iam delete-role --role-name $role_name
}

# delete_instance_profiles() {
#     local role_name=$1
#     aws iam list-instance-profiles-for-role --role-name $role_name --query 'InstanceProfiles[].InstanceProfileName' --output text | while read -r instance_profile; do
#         delete_instance_profile $instance_profile
#     done
# }

delete_instance_profile() {
    local instance_profile_name=$1
    
    # List roles attached to the instance profile
    role_names=$(aws iam list-instance-profiles-for-role --role-name $instance_profile_name --query 'Roles[].RoleName' --output text)
    
    # Detach each role from the instance profile
    for role_name in $role_names; do
        aws iam remove-role-from-instance-profile --instance-profile-name $instance_profile_name --role-name $role_name
    done
    
    # Delete the instance profile
    aws iam delete-instance-profile --instance-profile-name $instance_profile_name
}

