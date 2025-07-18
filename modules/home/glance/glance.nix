{
  lib,
  port,
  name,
  id,
  secret,
  ...
}: let
  hsl = h: s: l: [h s l] |> lib.map builtins.toString |> lib.concatStringsSep " ";
  readFileFromEnv = var: ''''${readFileFromEnv:${var}}'';
in {
  server = {
    port = readFileFromEnv port;
  };
  theme = {
    background-color = hsl 249 22 12;
    primary-color = hsl 2 55 83;
    positive-color = hsl 189 43 73;
    negative-color = hsl 343 76 68;
    presets = {
      default-dark = {
        light = false;
        background-color = hsl 246 24 17;
        primary-color = hsl 2 66 75;
        positive-color = hsl 189 43 73;
        negative-color = hsl 343 76 68;
      };
      default-light = {
        light = true;
        background-color = hsl 32 57 95;
        primary-color = hsl 268 21 57;
        positive-color = hsl 197 53 34;
        negative-color = hsl 343 35 55;
      };
    };
  };
  pages = [
    {
      name = "Home";
      columns = [
        {
          size = "small";
          widgets = [
            {
              type = "calendar";
              first-day-of-week = "monday";
            }
            {
              type = "clock";
              hour-format = "24h";
              timezones = [
                {
                  timezone = "Europe/Istanbul";
                  label = "Istanbul";
                }
                {
                  timezone = "America/New_York";
                  label = "Chattanooga";
                }
                {
                  timezone = "America/Chicago";
                  label = "Dallas";
                }
                {
                  timezone = "America/Los_Angeles";
                  label = "Seattle";
                }
              ];
            }
            {
              type = "rss";
              limit = 10;
              collapse-after = 3;
              cache = "12h";
              feeds = [
                {
                  url = "https://selfh.st/rss/";
                  title = "selfh.st";
                  limit = 4;
                }
                {
                  url = "https://ciechanow.ski/atom.xml";
                }
                {
                  url = "https://www.joshwcomeau.com/rss.xml";
                  title = "Josh Comeau";
                }
                {
                  url = "https://samwho.dev/rss.xml";
                }
                {
                  url = "https://ishadeed.com/feed.xml";
                  title = "Ahmad Shadeed";
                }
              ];
            }
          ];
        }
        {
          size = "full";
          widgets = [
            {
              type = "group";
              widgets = [
                {
                  type = "hacker-news";
                }
                {
                  type = "lobsters";
                }
              ];
            }
            {
              type = "videos";
              channels = [
                "UCsBjURrPoezykLs9EqgamOA" # Fireship
                "UCHnyfMqiRRG1u-2MsSQLbXA" # Veritasium
              ];
            }
            {
              type = "group";
              widgets = let
                app-auth = {
                  name = readFileFromEnv name;
                  id = readFileFromEnv id;
                  secret = readFileFromEnv secret;
                };
              in [
                {
                  inherit app-auth;
                  type = "reddit";
                  subreddit = "turkey";
                  show-thumbnails = true;
                }
                {
                  inherit app-auth;
                  type = "reddit";
                  subreddit = "technology";
                  show-thumbnails = true;
                }
                {
                  inherit app-auth;
                  type = "reddit";
                  subreddit = "selfhosted";
                  show-thumbnails = true;
                }
              ];
            }
          ];
        }
        {
          size = "small";
          widgets = [
            {
              type = "weather";
              location = "Gölcük, Kocaeli, Türkiye";
              units = "metric";
              hour-format = "24h";
            }
            {
              type = "markets";
              markets = [
                {
                  symbol = "USDTRY=X";
                  name = "USD-TRY";
                }
                {
                  symbol = "USDEUR=X";
                  name = "USD-EUR";
                }
                {
                  symbol = "EURTRY=X";
                  name = "EUR-TRY";
                }
                {
                  symbol = "DJIA";
                  name = "Dow Jones";
                }
                {
                  symbol = "^IXIC";
                  name = "NASDAQ";
                }
                {
                  symbol = "SPY";
                  name = "S&P 500";
                }
              ];
            }
            {
              type = "releases";
              cache = "1d";
              repositories = [
                "glanceapp/glance"
              ];
            }
          ];
        }
      ];
    }
    {
      name = "Delegator";
      columns = [
        {
          size = "full";
          widgets = [
            {
              type = "monitor";
              cache = "1m";
              title = "Sites";
              sites = [
                {
                  title = "Delegator";
                  url = "https://delegator.com";
                }
                {
                  title = "PlayCore";
                  url = "https://playcore.com";
                }
                {
                  title = "SLTC";
                  url = "https://lineworker.com";
                }
              ];
            }
          ];
        }
      ];
    }
  ];
}
