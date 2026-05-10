# Workstation (standalone home-manager on non-NixOS Linux)
{
  username = "skylar";
  email = "REDACTED";
  fullName = "Skylar Brown";
  gpgKey = "E51A3E86541F5FCF";
  timezone = "America/Los_Angeles";
  # Standalone home-manager: nix profile lives at $HOME/.nix-profile,
  # not /etc/profiles/per-user (which only exists on NixOS).
  isNixOS = false;
}
