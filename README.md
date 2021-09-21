# NATC 2021 DevOps Workshop by Microsoft

## Welcome to NATC 2021 DevOps workshop by Microsoft

This repo contains the links and tech artifacts for the workshop. We primarily use K.I.N.D. as our K8s clusters during this workshop.

We will cover the following topics -

### GitOps for your K8s clusters with FluxCD (https://fluxcd.io/)
1.	Install Flux
    On Mac -
    ```
    brew install fluxcd/tap/flux
    ```
    On Linux -
    ```
    curl -s https://fluxcd.io/install.sh | sudo bash
    ```
    On Windows -
    ```
    choco install flux
    ```
2.	Create GitHub Personal Token and export details
  a.	export GITHUB_TOKEN=<your-token>
  b.	export GITHUB_USER=<your-username>
3.	Check your k8s cluster -
  a.	flux check –pre
4.	Change context
  a.	kind export kubeconfig --name kind1
5.	Install flux on your cluster -
  a.	flux bootstrap github --owner=$GITHUB_USER --repository=fleet-infra --branch=main --path=./clusters/kind1 --personal
6.	Clone the repo -
  a.	git clone https://github.com/$GITHUB_USER/fleet-infra
  b.	cd fleet-infra
7.	Add podinfo repo to flux -
  a.	flux create source git podinfo --url=https://github.com/stefanprodan/podinfo --branch=master --interval=30s --export > ./clusters/kind1/podinfo-source.yaml
  b.	git add -A && git commit -m "Add podinfo GitRepository"
  c.	git push
8.	Create a Kustomization -
   a.	flux create kustomization podinfo \  --source=podinfo \  --path="./kustomize" \  --prune=true \  --validation=client \  --interval=5m \  --export > ./clusters/kind1/podinfo-kustomization.yaml
  b.	git add -A && git commit -m "Add podinfo Kustomization"
  c.	git push
9.	Watch flux sync the application -
  a.	flux get kustomizations --watch
10.	Check the pods/services
  a.	kubectl -n default get deployments,services
