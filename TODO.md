- Programming language roles (via asdf)
- Categorize remaining apps
- First-time setup for mariadb, postgres, apache, php

- 1Password role with GPG key install: 3FEF9748469ADBE15DA7CA80AC2D62742012EA22


- mariadb (mariadb mariadb-clients mariadb-libs)
- postgres (postgresql postgresql-libs)

- go
- crystal
- elixir(+erlang)
- netcore
- flutter(+dart)
- clojure(+java)
- php (asdf, with common plugins)

devops tooling:
- gcloud
- istioctl (asdf)
- linkerd (asdf)
- doctl

straight software installs:
- gitui - terminal UI for git repos (include in git role)


- php?


- elasticsearch?

- lua? LuaJIT?
- mongotools?
- mongodb?
- mongosh?
- mariadb?
- postgres?

- terraform?
- purescript?
- rust
- scala
- sqlite?
- terraform-lsp?
- terraform-validator?
- terraform-ls?
- terragrunt?
- tflint?
- tfsec?



- Helm chart unit tests in CI: https://github.com/helm/chart-testing
- GitHub Pages releases for helm charts: https://github.com/helm/chart-releaser
- Helm Chart docs helper for readme.md files: https://github.com/norwoodj/helm-docs
- interesting manual management of helm charts on a cluster: https://github.com/roboll/helmfile
- K8S TUI: https://github.com/derailed/k9s
- Framework for quick MVPs of K8S CRDs and controllers: https://github.com/kubernetes-sigs/kubebuilder

- Scanning usage metrics in a cluster: https://github.com/robscott/kube-capacity/ (requires metrics-server if you want to see real usage data in addition to defined limits on pods)
- Validating kubernetes manifest files: https://github.com/instrumenta/kubeval
- helpful tools to pin clusters and namespaces quickly: https://github.com/ahmetb/kubectx