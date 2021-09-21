## Install K.I.N.D -
1. On Linux -
```
  curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
  chmod +x ./kind
  mv ./kind /some-dir-in-your-PATH/kind
  ```
2. On Mac -
  ```
  brew install kind
  ```
3. On Windows -
  ```
  curl.exe -Lo kind-windows-amd64.exe https://kind.sigs.k8s.io/dl/v0.11.1/kind-windows-amd64
  Move-Item .\kind-windows-amd64.exe c:\some-dir-in-your-PATH\kind.exe
  ```
  Or,
  ```
  choco install kind
  ```
