{ self, ... }:
{
  inherit self;

  brews = [
    "awscli"
    "aws-iam-authenticator"
    "aws-sam-cli"
    "cairo"
    "checkov"
    "credstash"
    "fnm"
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
