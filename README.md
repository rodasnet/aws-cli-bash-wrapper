# aws-cli-bash-wrapper

## Load the functions library

```
source ./lib/load.sh

library_method1 --id 123 --json input.json

```

## Grant Lakeformation Permission With a Helper Command

```
 grant-lf-permission --admin   --catalog-id 123 --i "arn:aws:iam::123456789111:user/lf-admin"
 grant-lf-permission --manager --catalog-id 123 --i "arn:aws:iam::123456789111:user/lf-manager"
 grant-lf-permission --reader  --catalog-id 123 --i "arn:aws:iam::123456789111:user/lf-reader"
 grant-lf-permission --writer  --catalog-id 123 --i "arn:aws:iam::123456789111:user/lf-writer"
```

