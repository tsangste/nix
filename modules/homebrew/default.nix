{ username }:
{
  # Install Homebrew under the default prefix
  enable = true;

  # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
  enableRosetta = true;

  # User owning the Homebrew prefix
  user = username;
}
