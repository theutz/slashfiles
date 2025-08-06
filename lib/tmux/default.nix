{ lib, ... }:
{
  tmux = {
    mkCommandAliases =
      let
        mkAlias = (name: value: ''${name}="${value}"'');
        mkSetting = (
          index: value: index + 100 |> builtins.toString |> (key: ''set -g command-alias[${key}] ${value}'')
        );
      in
      aliases: aliases |> lib.mapAttrsToList mkAlias |> lib.imap0 mkSetting |> lib.concatLines;
  };
}
