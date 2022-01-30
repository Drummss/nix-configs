{
  project.name = "verdaccio";

  services = {
    verdaccio.service = {
      useHostStore = true;
      name = "verdaccio";
      image = "verdaccio/verdaccio";
      restart = "unless-stopped";
      volumes = [
        "/var/lib/verdaccio/storage:/opt/verdaccio/storage"
        "/var/lib/verdaccio/conf:/opt/verdaccio/conf"
        "/var/lib/verdaccio/plugins:/opt/verdaccio/plugins"
      ];
      environment = {
        VERDACCIO_PORT = 4873;
        VERDACCIO_PUBLIC_URL = "https://npmr.unkn.in/";
      };
      ports = [
        "127.0.0.1:7201:4873"
      ];
    };
  };
}