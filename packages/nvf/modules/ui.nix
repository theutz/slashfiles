{
  lib,
  config,
  ...
}:
let
  inherit (lib.nvim.binds) mkKeymap;
in
{
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

    binds.whichKey.register = lib.optionalAttrs config.vim.ui.noice.enable {
      "<leader>ve" = "errors";
    };

    keymaps = lib.optionals config.vim.ui.noice.enable [
      (mkKeymap [ "n" ] "<leader>vee" "<cmd>NoiceErrors<cr>" { desc = "Show errors"; })
      (mkKeymap [ "n" ] "<leader>ves" "<cmd>NoiceFzf<cr>" { desc = "Search errors"; })
    ];

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
              filter = {
                event = "msg_showmode";
              };
            }
          ];
        };
      };
    };
  };
}
