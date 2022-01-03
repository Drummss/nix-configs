{ buildGoModule, fetchFromGitHub, lib } :
buildGoModule rec {
  pname = "pterodactyl-wings";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-2Tdx37/rojpj2d9Pm7KV6MFNveYmEqbP94HaJuwT4O4=";
  };

  vendorSha256 = "sha256-QuLUEDH+YZUME1nE3P6HnWhZmSfCSORElS6+x0oWEjM=";

  runVend = true;

  meta = with lib; {
    description = "Wings is Pterodactyl's server control plane, built for the rapidly changing gaming industry and designed to be highly performant and secure.";
    homepage = "https://github.com/pterodactyl/wings";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}