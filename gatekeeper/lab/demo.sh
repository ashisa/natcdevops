#!/bin/bash

. ../../third_party/demo-magic/demo-magic.sh

clear

kubectl apply -f sync.yaml >> /dev/null
kubectl apply -f dryrun/existing_resources >> /dev/null

clear

echo "===== Developer1 starts a project ====="
echo

pe "kubectl create ns webapp-transactions"

p "Developer1 creates K8s objects in the namespace.."
echo

echo "===== After few weeks Developer1 moves to another project ====="
echo
wait
#NO_WAIT=false

clear
echo
echo "===== Admin Operations ====="
echo
pe "kubectl delete ns webapp-transactions"

pe "ls -1 templates2"
echo
pe "kubectl apply -f templates2"
echo
p "Admin now puts in some restrictive constraints in place..."

pe "ls -1 constraints2"
echo


pe "cat constraints2/owner_must_be_provided.yaml"
echo

pe "cat constraints2/containers_must_be_limited.yaml"
echo

pe "cat constraints2/probes_must_be_provided.yaml"
echo

pe "kubectl apply -f constraints2"
echo

echo "===== Developer2 starts a new project ======"
echo

pe "kubectl create ns webapp-production"
echo

pe "cat good_resources/namespace.yaml"
echo

pe "kubectl apply -f good_resources/namespace.yaml"
echo

pe "kubectl apply -f bad_resources/opa_no_limits.yaml"
echo

pe "kubectl apply -f bad_resources/opa_limits_too_high.yaml"
echo
pe "kubectl apply -f good_resources/opa.yaml"
echo

pe "cat good_resources/good_pod.yaml"

pe "kubectl apply -f good_resources/good_pod.yaml"

p "After making necessary updates to align to the policies, the developer's service is up and running"

echo
echo "================================="

p "We had no idea there were already resources in the cluster without resource limits. Now they are causing issues in production!"
echo
read

NO_WAIT=false
pe "kubectl get k8scontainerlimits.constraints.gatekeeper.sh  container-must-have-limits -o yaml"
echo



