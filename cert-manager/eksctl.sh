export CLUSTER=test-cluster-1

eksctl create cluster \
  --name $CLUSTER \
  --nodegroup-name node-group-1 \
  --node-type t3.small \
  --nodes 3 \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed \
  --spot
