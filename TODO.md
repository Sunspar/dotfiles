- Categorize remaining config into role folders

- language/elixir
- language/erlang
- language/java
- language/clojure
- language/rust
- language/go
- language/lua (luajit?)
- devops/core: gcloud, doctl
- devops/kubernetes: istioctl (asdf), linkerd (asdf)
- devops/terraform:
    - terraform-validator
    - terraform-ls
    - terraform
    - terragrunt
    - tflint
    - tfsec
- database/mariadb (mariadb mariadb-clients mariadb-libs)
- database/postgresql (postgresql postgresql-libs, pg ident and conf files)
- database/mongodb (mongodb, compass,config files)
- security/1password 
    - GPG Key: 3FEF9748469ADBE15DA7CA80AC2D62742012EA22
    - packages (cli, desktop app)
    

Useful things to check out:
- Helm chart unit tests in CI: https://github.com/helm/chart-testing
- GitHub Pages releases for helm charts: https://github.com/helm/chart-releaser
- Helm Chart docs helper for readme.md files: https://github.com/norwoodj/helm-docs
- interesting manual management of helm charts on a cluster: https://github.com/roboll/helmfile
- K8S TUI: https://github.com/derailed/k9s
- Framework for quick MVPs of K8S CRDs and controllers: https://github.com/kubernetes-sigs/kubebuilder
- Scanning usage metrics in a cluster: https://github.com/robscott/kube-capacity/ (requires metrics-server if you want to see real usage data in addition to defined limits on pods)
- Validating kubernetes manifest files: https://github.com/instrumenta/kubeval
- helpful tools to pin clusters and namespaces quickly: https://github.com/ahmetb/kubectx