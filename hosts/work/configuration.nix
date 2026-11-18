{ self, username, pkgs, lib, ... }:
let
  sslCertFile = "/Users/${username}/.config/certs/company.pem";
  junieCaAlias = "corporate-gateway-ca";
  keytool = "${pkgs.openjdk}/bin/keytool";
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

  # Junie ships a bundled JRE and ignores SSL_CERT_FILE; trust the corporate intercept CA
  # in its Java cacerts keystore (same idea as importing a Zscaler root via keytool).
  system.activationScripts.postActivation.text = lib.mkAfter ''
    companyCert="${sslCertFile}"
    if [ ! -f "$companyCert" ]; then
      echo "junieCorporateCa: skipping, $companyCert not found" >&2
    else
      find "/Users/${username}/.local/share/junie/versions" "/opt/homebrew/Cellar/junie" \
        -path '*/lib/security/cacerts' -type f 2>/dev/null |
      while read -r cacerts; do
        if ${keytool} -list -keystore "$cacerts" -storepass changeit -alias ${junieCaAlias} >/dev/null 2>&1; then
          echo "junieCorporateCa: ${junieCaAlias} already trusted in $cacerts" >&2
        else
          echo "junieCorporateCa: importing into $cacerts" >&2
          # Junie tags the downloaded runtime with com.apple.provenance.
          # darwin-rebuild runs as root, and macOS then refuses keytool's
          # in-place rewrite: "Operation not permitted".
          /usr/bin/xattr -d com.apple.provenance "$cacerts" 2>/dev/null || true
          ${keytool} -importcert -noprompt \
            -alias ${junieCaAlias} \
            -file "$companyCert" \
            -keystore "$cacerts" \
            -storepass changeit
        fi
      done
    fi
  '';

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
    "istioctl"
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
    "uv"
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

  # cleanup = "zap" uninstalls every Mac App Store app missing from the Brewfile.
  # These are installed outside Homebrew and owned by root, so mas uninstall
  # fails when it cannot chown them.
  masApps = {
    "Microsoft PowerPoint" = 462062816;
  };
}
