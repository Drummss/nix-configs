{
  project.name = "ovenmediaengine";

  services = {
    ovenmediaengine.service = {
      useHostStore = true;
      name = "ovenmediaengine";
      image = "airensoft/ovenmediaengine";
      restart = "unless-stopped";
      volumes = [
        "/var/lib/ovenmediaengine/ome-origin-conf:/opt/ovenmediaengine/bin/origin_conf"
        "/var/lib/ovenmediaengine/ome-edge-conf:/opt/ovenmediaengine/bin/edge_conf"
      ];
      environment = {
        OME_SIGNALLING_PORT = "7601";
        OME_API_PORT = "7602";
      };
      ports = [
        "1935:1935"
        "9999:9999"
        "9000:9000"
        "7600:80"
        "7601:7601"
	"127.0.0.1:7602:7602"
        "3478:3478"
      ];
    };
  };
}
