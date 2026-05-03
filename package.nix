{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  curl,
  jq,
  xdg-utils,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "prowlet";

  # Upstream has no releases. Pin to a specific commit and update manually.
  # To get the correct values, run:
  #   nix-prefetch-github loiccoyle prowlet --rev <commit-sha>
  version = "unstable-2024-03-01"; # update to match the date of the pinned commit

  src = fetchFromGitHub {
    owner = "loiccoyle";
    repo = "prowlet";
    rev = "a5e92ca8837c9fec82bddad42afc6958e4340676";
    hash = "sha256-8dnCseHH+y4yY/2qaR9bHDSqG2kL5aenHdZFat/7Fyg=";
  };

  nativeBuildInputs = [makeWrapper];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 prowlet $out/bin/prowlet

    # Shell completions
    install -Dm644 completions/bash $out/share/bash-completion/completions/prowlet
    install -Dm644 completions/zsh  $out/share/zsh/site-functions/_prowlet
    install -Dm644 completions/fish $out/share/fish/vendor_completions.d/prowlet.fish

    wrapProgram $out/bin/prowlet \
      --prefix PATH : ${lib.makeBinPath [
      curl # HTTP requests to Prowlarr API
      jq # JSON parsing and output formatting
      xdg-utils # xdg-open for 'prowlet open' subcommand
    ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Query the Prowlarr search API from the command line";
    homepage = "https://github.com/loiccoyle/prowlet";
    license = licenses.mit;
    mainProgram = "prowlet";
    # xdg-open and systemctl (-s/-k flags) are Linux-specific
    platforms = platforms.linux;
  };
})
