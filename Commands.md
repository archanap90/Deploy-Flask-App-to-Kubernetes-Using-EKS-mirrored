docker build --tag jwt-api-test:8.0 .

docker run --publish 80:8080 --env-file ./env_file --detach --name jwt-api-test-7 jwt-api-test:5.0

brew install weaveworks/tap/eksctl
pipenv run eksctl create cluster --name simple-jwt-api 
pipenv run aws ssm put-parameter --name JWT_SECRET --value "<SECRET>" --type SecureString


ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

TRUST="{ \"Version\": \"2012-10-17\", \"Statement\": [ { \"Effect\": \"Allow\",  \"Principal\": { \"AWS\": \"arn:aws:iam::${ACCOUNT_ID}:root\" }, \"Action\":  \"sts:AssumeRole\" } ] }"

aws iam create-role --role-name UdacityFlaskDeployCBKubectlRole --assume-role-policy-document "$TRUST" --output text --query 'Role.Arn'

echo '{ "Version": "2012-10-17", "Statement": [ { "Effect": "Allow", "Action": [ "eks:Describe*", "ssm:GetParameters" ], "Resource": "*" } ] }' > ./iam-role-policy

aws iam put-role-policy --role-name UdacityFlaskDeployCBKubectlRole --policy-name eks-describe --policy-document file://./iam-role-policy

kubectl get -n kube-system configmap/aws-auth -o yaml > ./aws-auth-patch.yml

kubectl patch configmap/aws-auth -n kube-system --patch "$(cat ./aws-auth-patch.yml)"

pipenv run kubectl get services simple-jwt-api -o wide