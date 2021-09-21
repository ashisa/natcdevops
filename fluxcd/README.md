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
    ```
7.	Add podinfo repo to flux -
    ```
    cd fleet-infra
    flux create source git podinfo --url=https://github.com/stefanprodan/podinfo --branch=master --interval=30s --export > ./clusters/kind1/podinfo-source.yaml
    git add -A && git commit -m "Add podinfo GitRepository"
    git push
    ```
8.	Create a Kustomization -
    ```
    flux create kustomization podinfo \  
    --source=podinfo \  
    --path="./kustomize" \  
    --prune=true \  
    --validation=client \  
    --interval=5m \  
    --export > ./clusters/kind1/podinfo-kustomization.yaml
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
11. Check the GitRepository CRDs added to your cluster -
    ```
    kubectl get gitrepository -A
    ```
12. Let's install another app to our cluster now -
    ```
    flux create source git demoapp \
    --url=https://github.com/ashisa/aks-flux \
    --branch=main \
    --interval=30s \
    --export > ./clusters/kind1/demoapp-source.yaml
    
    git add -A && git commit -m "Add DemoApp GitRepository"
    git push
    
    flux create kustomization demoapp \
    --source=demoapp \
    --path="./manifests" \
    --prune=true \
    --validation=client \
    --interval=5m \
    --export > ./clusters/kind1/demoapp-kustomization.yaml
    
    git add -A && git commit -m "Add DemoApp Kustomization"
    git push
    
    flux get kustomizations --watch
    
    kubectl get deployments,services,pods -A
    ```
13. You can access the web app with a port-forward
    ```
    kubectl port-forward service/podinfo 9898
    kubectl port-forward service/demoapp 8080:80
    ```
14. Create an indentical environment in another cluster (assumes kind2 as the other cluster) -
    ```
    kind export kubeconfig --name kind2
    
    flux bootstrap github \
    --context=kind-kind2 \
    --owner=${GITHUB_USER} \
    --repository=fleet-infra \
    --branch=main \
    --personal \
    --path=clusters/kind2

    git pull origin main
    ```
15. Add Kustomization to ./cluster/kind2/kustomization.yaml that points to the artifacts from the other cluster -
    ```
    apiVersion: kustomize.config.k8s.io/v1beta1
    kind: Kustomization
    resources:
      - flux-system
      - ../kind1/podinfo-kustomization.yaml
      - ../kind1/podinfo-source.yaml
    ```
16. Commit and merge the changes -
    ```
    git add -A && git commit -m "add clone"
    git push

    flux reconcile kustomization flux-system \
    --context=kind-kind2 \
    --with-source 

    ```
.
