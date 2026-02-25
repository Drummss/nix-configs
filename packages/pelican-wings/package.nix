{
  buildGoModule,
  fetchFromGitHub,
  go_1_25,
}: buildGoModule rec {
  pname = "pelican-wings";
  version = "1.0.0-beta22";
  go = go_1_25;

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "wings";
    rev = "v${version}";
    hash = "sha256-CVH3oiqDa/kLEstvLwO45/jetKI/V1wlrXK1C+CVzgs=";
  };

  vendorHash = "sha256-Nkz9qz8rh+1dO9lGrTLLO0mOXLtcQmxi1R1jGxWiKic=";

  # subPackages = [ "cmd/wings" ];

  ldflags = [ "-s" "-w" ];
}
