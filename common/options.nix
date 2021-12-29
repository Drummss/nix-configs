{ lib, ... }:
with lib;
{
  options.unknin = {
    domain = mkOption {
      default = "unkn.in";
      type = types.str;
      description = "Primary domain governing lots of configuration options for the host";
    };
  };
}
