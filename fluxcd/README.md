## GitOps for your K8s clusters with FluxCD (https://fluxcd.io/)
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
    ```
    export GITHUB_TOKEN=<your-token>
    export GITHUB_USER=<your-username>
    ```
3.	Check your k8s cluster -
    ```
    flux check –pre
    ```
4.	Change context as needed -
    ```
    kind export kubeconfig --name kind1
    ```
5.	Install flux on your cluster -
    ```
    flux bootstrap github --owner=$GITHUB_USER --repository=fleet-infra --branch=main --path=./clusters/kind1 --personal
    ```
6.	Clone the repo -
    ```
    git clone https://github.com/$GITHUB_USER/fleet-infra
    cd fleet-infra
    ```
7.	Add podinfo repo to flux -
    ```
    flux create source git podinfo --url=https://github.com/stefanprodan/podinfo --branch=master --interval=30s --export > ./clusters/kind1/podinfo-source.yaml
    git add -A && git commit -m "Add podinfo GitRepository"
    git push
    ```
8.	Create a Kustomization -
    ```
    flux create kustomization podinfo \  --source=podinfo \  --path="./kustomize" \  --prune=true \  --validation=client \  --interval=5m \  --export > ./clusters/kind1/podinfo-kustomization.yaml
    git add -A && git commit -m "Add podinfo Kustomization"
    git push
    ```
9.	Watch flux sync the application -
    ```
    flux get kustomizations --watch
    ```
10.	Check the pods/services
    ```
    kubectl get deployments,services,pods -A
    ```
