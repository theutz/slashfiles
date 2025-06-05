{lib, ...}: {
  mkMenu = {
    name,
    key,
    mkItems,
    x ? "#{popup_pane_left}",
    y ? "#{popup_pane_bottom}",
  }:
    lib.concatStringsSep " " [
      "bind-key"
      ''-N "Open '${name |> lib.strings.toSentenceCase}' menu"''
      key
      ''display-menu -T "${name |> lib.strings.toSentenceCase}..."''
      ''-x "${x}"''
      ''-y "${y}"''
      (mkItems {
          divider = "''";
          mkItem = key: name: command: (''
              "${name |> lib.strings.trim |> lib.strings.toSentenceCase}" ${key |> lib.strings.trim} {
                ${command |> lib.strings.trim}
              }
            ''
            |> lib.strings.trim);
        }
        |> lib.strings.intersperse " "
        |> lib.strings.concatStrings)
    ];

  mkPopup = {
    title,
    command,
    env ? {},
    autoClose ? "success",
    border ? true,
    closeOthers ? false,
    x ? "C",
    y ? "C",
    w ? "90%",
    h ? "90%",
  }: let
    B =
      if border
      then ""
      else "-B";
    C =
      if closeOthers
      then "-C"
      else "";
    E =
      if autoClose == "success"
      then "-EE"
      else if autoClose == "always"
      then "-E"
      else "";
    e =
      env
      |> lib.attrsets.mapAttrsToList (name: value: ''-e ${name}="${builtins.toString value}"'')
      |> lib.concatLines
      |> lib.strings.trim;
  in
    [
      "display-popup"
      B
      C
      E
      ''-x "${x}"''
      ''-y "${y}"''
      ''-h "${builtins.toString h}"''
      ''-w "${builtins.toString w}"''
      ''-T "${title |> lib.strings.trim |> lib.strings.toSentenceCase}"''
      e
      (command |> lib.strings.trim)
    ]
    |> lib.strings.concatStringsSep " ";
}
