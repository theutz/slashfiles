{
  config,
  lib,
  namespace,
  ...
}: let
  parent = builtins.baseNameOf ./.;
  mod = lib.${namespace}.thisHere __curPos;
  cfg = config.${namespace}.${parent}.${mod};
in {
  options.${namespace}.${parent}.${mod}.enable = lib.mkEnableOption "${parent} > ${mod}";

  config = lib.mkIf cfg.enable {
    programs.tmux.extraConfig = ''
      # Smart pane switching with awareness of Neovim splits.
      bind-key -N "Smart switch pane left" -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h'  'select-pane -L'
      bind-key -N "Smart switch pane down" -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j'  'select-pane -D'
      bind-key -N "Smart switch pane up" -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k'  'select-pane -U'
      bind-key -N "Smart switch pane right" -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l'  'select-pane -R'
      bind-key -n C-\\ if -F "#{@pane-is-vim}" 'send-keys C-\\' 'select-pane -l'

      # Smart pane resizing with awareness of Neovim splits.
      bind-key -N "Smart resize left" -n M-H if -F "#{@pane-is-vim}" 'send-keys M-H' 'resize-pane -L 3'
      bind-key -N "Smart resize down" -n M-J if -F "#{@pane-is-vim}" 'send-keys M-J' 'resize-pane -D 3'
      bind-key -N "Smart resize up" -n M-K if -F "#{@pane-is-vim}" 'send-keys M-K' 'resize-pane -U 3'
      bind-key -N "Smart resize right" -n M-L if -F "#{@pane-is-vim}" 'send-keys M-L' 'resize-pane -R 3'

      # Copy mode bindings
      bind-key -N "Smart switch pane left" -T copy-mode-vi 'C-h' select-pane -L
      bind-key -N "Smart switch pane down" -T copy-mode-vi 'C-j' select-pane -D
      bind-key -N "Smart switch pane up" -T copy-mode-vi 'C-k' select-pane -U
      bind-key -N "Smart switch pane right" -T copy-mode-vi 'C-l' select-pane -R
      bind-key -N "Smart switch pane last" -T copy-mode-vi 'C-\' select-pane -l
    '';
  };
}
