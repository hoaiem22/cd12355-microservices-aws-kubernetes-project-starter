eksctl create cluster --name coworking-cluster --region us-east-1 --nodegroup-name coworking-nodes --node-type t3.small --nodes 1 --nodes-min 1 --nodes-max 2

aws eks --region us-east-1 update-kubeconfig --name coworking-cluster

psql -U coworking -d coworking

# Set up port-forwarding to `postgresql-service`
kubectl port-forward service/postgresql-service 5433:5432 &
ps aux | grep 'kubectl port-forward' | grep -v grep | awk '{print $2}' | xargs -r kill

python3 -m venv venv  
source venv/bin/activate
pip3 install -r requirements.txt
deactivate
rm -rf venv

curl 127.0.0.1:5153/api/reports/daily_usage
curl 127.0.0.1:5153/api/reports/user_visits

docker build -t test-coworking-analytics .
docker run --network="host" test-coworking-analytics
