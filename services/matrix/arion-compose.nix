{
  project.name = "Matrix";

  services = {
    # Element Frontend
    element.service = {
      useHostStore = true;
      name = "matrix-element";
      image = "vectorim/element-web:latest";
      restart = "unless-stopped";
      volumes = [
        "/var/lib/matrix/element/element-config.json:/app/config.json"
      ];
      ports = [
        "127.0.0.1:7101:80"
      ];
    };

    # Matrix/Synapse Backend
    synapse.service = {
      useHostStore = true;
      name = "matrix-synapse";
      image = "matrixdotorg/synapse:latest";
      restart = "unless-stopped";
      volumes = [
        "/var/lib/matrix/synapse:/data"
      ];
      ports = [
        "127.0.0.1:7100:8008"
      ];
    };
  };
}