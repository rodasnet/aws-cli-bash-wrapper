aws s3api create-bucket --cli-input-json file://bucket-config.json

aws s3api create-bucket --cli-input-json '{"Bucket": "ohbabyilikeitraw", "CreateBucketConfiguration": {"LocationConstraint": "us-west-2"}}'