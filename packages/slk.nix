{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  libX11,
  stdenv,
}:

buildGo126Module rec {
  pname = "slk";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "gammons";
    repo = "slk";
    rev = "v${version}";
    hash = "sha256-Suno3T4epmXifaEzeJ93w5UWcNMW8+Olg5i8mUxLIUk=";
  };

  vendorHash = "sha256-deqCUDgRvhe/Bpmy+9bIHjSBo+KTCtAN2XcGMhAj/G0=";

  subPackages = [ "cmd/slk" ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libX11 ];

  meta = {
    description = "A blazingly fast Slack TUI";
    homepage = "https://github.com/gammons/slk";
    license = lib.licenses.mit;
    mainProgram = "slk";
  };
}
