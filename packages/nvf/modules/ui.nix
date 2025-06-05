{lib, ...}: let
  inherit (lib.generators) mkLuaInline;
in {
  config.vim = {
    statusline.lualine = {
      enable = true;

      # FIXME: Don't know why this isn't working
      extraActiveSection.b = [
        # lua
        ''
          {
            require("noice").api.statusline.mode.get,
            cond = require("noice").api.statusline.mode.has,
            color = { fg = "#ff9e64" },
          },
        ''
      ];
    };

    ui = {
      breadcrumbs = {
        enable = true;
      };

      borders = {
        enable = true;
        globalStyle = "rounded";
      };

      noice = {
        enable = true;
        setupOpts = {
          routes = [
            {
              view = "notify";
              filter = {event = "msg_showmode";};
            }
          ];
        };
      };
    };
  };
}
