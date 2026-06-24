{ self, username, ... }:
let
  sslCertFile = "/Users/${username}/.config/certs/ca-bundle-combined.pem";
in
{
  inherit self;

  # zsh sessionVariables do not reach nix-daemon; configure SSL at the system level.
  nix.settings.ssl-cert-file = sslCertFile;

  environment.variables = {
    NIX_SSL_CERT_FILE = sslCertFile;
    SSL_CERT_FILE = sslCertFile;
    REQUEST_CA_BUNDLE = sslCertFile;
    NODE_EXTRA_CA_CERTS = sslCertFile;
  };

  brews = [
    "awscli"
    "aws-iam-authenticator"
    "aws-sam-cli"
    "cairo"
    "checkov"
    "credstash"
    "fnm"
    "gh"
    "helm"
    "junie"
    "kubectl"
    "pango"
    "pixman"
    "pipx"
    "pre-commit"
    "pyenv-virtualenv"
    "python-setuptools"
    "pipenv"
    "tilt"
    "yarn"
    "yq"
  ];
  casks = [
    "docker-desktop"
    "lens"
    "postman"
    "session-manager-plugin"
    "Tuple"
  ];
}
