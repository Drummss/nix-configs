{
  project.name = "pandabot";

  services = {
    redis.service = {
      useHostStore = true;
      name = "redis";
      image = "redis:latest";
      restart = "unless-stopped";
      volumes = [
        "/var/lib/pandabot/data/redis:/var/lib/redis"
        # "./redis.conf:/usr/local/etc/redis/redis.conf"
      ];
    };

    db.service = {
      useHostStore = true;
      name = "db";
      image = "postgres:latest";
      restart = "unless-stopped";
      volumes = [
        "/var/lib/pandabot/data/database:/var/lib/postgresql/data"
      ];
      environment = {
        POSTGRES_USER = "postgres";
        POSTGRES_PASSWORD = "postgres";
        POSTGRES_DB = "pandabot";
      };
      ports = [
	      # "127.0.0.1:7801:5432"
      ];
    };

    api.service = {
      useHostStore = true;
      name = "api";
      image = "pandabot-api-service:latest";
      restart = "unless-stopped";
      environment = {
        DATABASE_URL = "postgresql://postgres:postgres@db:5432/pandabot?schema=public";
        PORT = 7800;
      };
      ports = [
	      "127.0.0.1:7800:7800"
      ];
      depends_on = [
        "db"
      ];
    };

    bot.service = {
      useHostStore = true;
      name = "bot";
      image = "pandabot-bot:latest";
      restart = "unless-stopped";
      environment = {
        API_ENDPOINT = "http://api:7800/";
      };
      env_file = [ "/var/secrets/pandabot.env" ];
      #volumes = [ "/var/lib/pandabot/secrets:/var/lib/pandabot/secrets:ro" ];
      depends_on = [
        "api"
      ];
    };

    dashboard.service = {
      useHostStore = true;
      name = "dashboard";
      image = "pandabot-dashboard:latest";
      restart = "unless-stopped";
      ports = [
	      "127.0.0.1:7801:3000"
      ];
      environment = {
        CALLBACK_URL = "https://www.pandabot.one";
        REDIS_URL = "redis://redis:6379";
        APISERVICE_URL = "http://api:7800";
        NEXTAUTH_URL = "https://www.pandabot.one";
      };
      env_file = [ "/var/secrets/pandabot.env" ];
      #volumes = [ "/var/lib/pandabot/secrets:/var/lib/pandabot/secrets:ro" ];
      depends_on = [
        "redis"
      ];
    };
  };
}
