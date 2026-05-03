{ lib, stdenvNoCC, fetchFromGitHub, makeWrapper, curl, jq, xdg-utils }:

stdenvNoCC.mkDerivation rec {
  pname = "prowlet";
  version = "unstable-2024-03-01"; # Based on latest activity

  src = fetchFromGitHub {
    owner = "loiccoyle";
    repo = "prowlet";
    rev = "main";
    hash = "sha256-8dnCseHH+y4yY/2qaR9bHDSqG2kL5aenHdZFat/7Fyg="; # Placeholder, will update
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 prowlet $out/bin/prowlet
    
    wrapProgram $out/bin/prowlet \
      --prefix PATH : ${lib.makeBinPath [ curl jq xdg-utils ]}
  '';

  meta = with lib; {
    description = "Query the Prowlarr search API from the CLI";
    homepage = "https://github.com/loiccoyle/prowlet";
    license = licenses.mit;
    mainProgram = "prowlet";
  };
}
