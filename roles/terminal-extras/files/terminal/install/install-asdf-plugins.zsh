# Setup Node LTS
asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 14.16.1
asdf global nodejs 14.16.1
asdf reshim nodejs

# Setup Yarn
asdf plugin-add yarn
asdf install yarn 1.22.10
asdf global yarn 1.22.10
asdf reshim yarn

# Setup Helm
asdf plugin-add helm
asdf install helm 3.5.4
asdf global helm 3.5.4
asdf reshim helm

# Setup Kubectl
asdf plugin-add kubectl
asdf install kubectl 1.21.0
asdf install kubectl 1.20.6
asdf install kubectl 1.19.10
asdf install kubectl 1.18.18
asdf global kubectl 1.21.0
asdf reshim kubectl

# Setup Ruby
asdf plugin-add ruby
asdf install ruby 3.0.1
asdf install ruby 2.7.3
asdf global ruby 2.7.3
asdf reshim ruby

# Setup Elixir (and Erlang)
# Important to note here is that the version of Elixir you choose ties you to a specific release of
# Erlang/OTP, so make sure oyu use compatible versions.
asdf plugin-add erlang
asdf install erlang 24.0.1
asdf global erlang 24.0.1
asdf reshim erlang

asdf plugin-add elixir
asdf install elixir 1.12.1-otp-24
asdf global elixir 1.12.1-otp-24
asdf reshim elixir

# Setup Rust
asdf plugin-add rust
asdf install rust 1.52.1
asdf global rust 1.52.1
asdf reshim rust

# Setup Go
asdf plugin-add golang
asdf install golang 1.16.4
asdf global golang 1.16.4
asdf reshim golang

# Setup flutter
asdf plugin-add flutter
asdf install flutter 2.2.1-stable
asdf global flutter 2.2.1-stable
asdf reshim flutter

# Setup Java
asdf plugin-add java
asdf install java openjdk-16.0.1
asdf global java openjdk-16.0.1
asdf reshim java