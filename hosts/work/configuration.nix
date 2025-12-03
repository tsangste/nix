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
    "kubectl"
    "pango"
    "pixman"
    "pipx"
    "pre-commit"
    "pyenv-virtualenv"
    "python-setuptools"
    "pipenv"
    "terraform-docs"
    "tilt"
    "tfenv"
    "tflint"
    "yarn"
    "yq"
  ];
  casks = [
    "docker"
    "lens"
    "postman"
    "session-manager-plugin"
    "Tuple"
  ];
}
