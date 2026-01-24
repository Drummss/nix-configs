{ buildGoModule, fetchFromGitHub, lib } :
buildGoModule rec {
  pname = "pterodactyl-wings";
  version = "1.11.6";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-lDJ0/yxmS7+9TVp3YpEdQQb12R4i2GyQ0w6RXoC5NHs=";
  };

  vendorHash = "sha256-by5MdlpT4ODkY/1WZkqWaQzC/ilBCyfqRTOGTAYJAdE=";

  proxyVendor = true;

  meta = with lib; {
    description = "Wings is Pterodactyl's server control plane, built for the rapidly changing gaming industry and designed to be highly performant and secure.";
    homepage = "https://github.com/pterodactyl/wings";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
