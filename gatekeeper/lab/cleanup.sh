kubectl delete -f dryrun/existing_resources
kubectl delete -f dryrun/bad_resource/
kubectl delete -f dryrun
kubectl delete -f good_resources
kubectl delete ns advanced-transaction-system
kubectl delete -f constraints2
kubectl delete -f templates2
kubectl delete -f sync.yaml
