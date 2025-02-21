# Delete IAM Roles

## Using CLI Wrapper
### Load Library Commands
```
source ./lib/load.sh
```
### Remove Instance Profile

```
remove_role_from_instance_profile SampleEc2Role
```
### Delete Role Policies

```
delete_role_policies SampleEc2Role
```
### Detach Role Profile

```
detach_role_policies SampleEc2Role
```
### Delete Instance Profile

```
delete_instance_profile SampleEc2Role
```
### Delete Instance Profile

```
delete_instance_profile SampleEc2Role
```
### Delete Role

```
delete_role SampleEc2Role
```

## AWS CLI Commands

### List all instance profiles that the rule is associated with enter the following command

```
aws iam list-instance-profiles-for-role --role-name SampleEc2Role  
```

### Output Instance Profile List

```
{
    "InstanceProfiles": [
        {
            "Path": "/",
            "InstanceProfileName": "SampleEc2Role",
            "InstanceProfileId": "AIPA2PFPEAVHLMH3WKTX7",
            "Arn": "arn:aws:iam::719774287182:instance-profile/SampleEc2Role",
            "CreateDate": "2023-01-19T05:50:38+00:00",
            "Roles": [
                {
                    "Path": "/",
                    "RoleName": "SampleEc2Role",
                    "RoleId": "AROA2PFPEAVHITNUJZMNP",
                    "Arn": "arn:aws:iam::719774287182:role/SampleEc2Role",
                    "CreateDate": "2023-01-19T05:50:36+00:00",
                    "AssumeRolePolicyDocument": {
                        "Version": "2012-10-17",
                        "Statement": [
                            {
                                "Effect": "Allow",
                                "Principal": {
                                    "Service": "ec2.amazonaws.com"
                                },
                                "Action": "sts:AssumeRole"
                            }
                        ]
                    }
                }
            ]
        }
    ]
}
```

### Remove Role from an Instance Profile

```
aws iam remove-role-from-instance-profile --instance-profile-name SampleEc2Role --role-name SampleEc2Role
```

### Add Role from an Instance Profile

```
aws iam add-role-to-instance-profile --instance-profile-name SampleEc2Role --role-name SampleEc2Role
```

### List Inline Policies

```
aws iam list-role-policies --role-name SampleEc2Role
```

### Output Inline Policies List

```
{
    "PolicyNames": []
}
```

### Delete Inline Policy

```
aws iam delete-role-policy --role-name SampleEc2Role --policy-name SampleEc2Role
```

### List Attached Role Policy

```
aws iam list-attached-role-policies --role-name SampleEc2Role
```

### Output Attached Role Policy

```
{
    "AttachedPolicies": [
        {
            "PolicyName": "AmazonRDSFullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
        },
        {
            "PolicyName": "AmazonS3FullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonS3FullAccess"
        }
    ]
}
```

### Detach Role for Policy

```
account_number=1234567890
policy_1=my-policy
policy_2=SecurityAudit

aws iam detach-role-policy --role-name SampleEc2Role --policy-arn "arn:aws:iam::${account_number}:policy/${policy_1}"
aws iam detach-role-policy --role-name SampleEc2Role --policy-arn "arn:aws:iam::aws:policy/${policy_2}"
```

### Delete Role

```
aws iam delete-role --role-name SampleEc2Role
```
