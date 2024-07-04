eksctl create cluster --name coworking-cluster --region us-east-1 --nodegroup-name coworking-nodes --node-type t3.small --nodes 1 --nodes-min 1 --nodes-max 2

aws eks --region us-east-1 update-kubeconfig --name coworking-cluster

psql -U coworking -d coworking

# Set up port-forwarding to `postgresql-service`
kubectl port-forward service/postgresql-service 5433:5432 &
ps aux | grep 'kubectl port-forward' | grep -v grep | awk '{print $2}' | xargs -r kill

PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U coworking -d coworking -p 5433

python3 -m venv venv  
source venv/bin/activate
pip3 install -r requirements.txt
deactivate
rm -rf venv


export DB_USERNAME=coworking
export DB_PASSWORD=${POSTGRES_PASSWORD}
export DB_HOST=127.0.0.1
export DB_PORT=5433
export DB_NAME=coworking
python app.py

curl 127.0.0.1:5153/api/reports/daily_usage
curl 127.0.0.1:5153/api/reports/user_visits

docker build -t coworking .
docker run --network="host" test-coworking-analytics


aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 536577976564.dkr.ecr.us-east-1.amazonaws.com
docker build -t coworking .
docker tag coworking:latest 536577976564.dkr.ecr.us-east-1.amazonaws.com/coworking:latest
docker push 536577976564.dkr.ecr.us-east-1.amazonaws.com/coworking:latest

curl aabe0102f83134eb0bbf035a56ed2a2f-1463734127.us-east-1.elb.amazonaws.com:5153/api/reports/daily_usage

aws iam attach-role-policy \
--role-name eksctl-coworking-cluster-nodegroup-NodeInstanceRole-t4n9402e2NWl \
--policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

aws eks create-addon --addon-name amazon-cloudwatch-observability --cluster-name coworking-cluster

curl aabe0102f83134eb0bbf035a56ed2a2f-1463734127.us-east-1.elb.amazonaws.com:5153/api/reports/daily_usage

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install postgresql-service bitnami/postgresql --set primary.persistence.enabled=false

kubectl get secret --namespace default postgresql-service -o jsonpath="{.data.postgresql-password}" | base64 --decode

psql --host 127.0.0.1 -U coworking -d coworking -p 5433

psql --host 127.0.0.1 -U postgres -d postgres -p 5432
ehQmy6xZQh

PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U coworking -d coworking -p 5433 -c "CREATE USER coworking WITH LOGIN;"
PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U coworking -d coworking -p 5433 -c "ALTER ROLE coworking WITH PASSWORD 'coworking!';"
PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U coworking -d coworking -p 5433 -c "ALTER ROLE coworking WITH SUPERUSER;"

kubectl port-forward --namespace default svc/postgresql-service 5432:5432 &