# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  namespace,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./networking.nix
    ./users.nix
    ./nix-index.nix
  ];

  "${namespace}" = {
    kanata.enable = true;
    secrets.enable = true;
    home-manager.enable = true;
    hyprland.enable = true;
  };

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  hardware = {
    # Bluetooth
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # List services that you want to enable:
  services = {
    # Enable the X11 windowing system.
    xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    xserver.displayManager.gdm.enable = true;
    xserver.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };

  security.rtkit.enable = true;

  programs = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    # Install 1password
    _1password.enable = true;
    _1password-gui.enable = true;

    # Install firefox.
    firefox.enable = true;

    # Install vim
    vim.enable = true;
    vim.defaultEditor = true;
  };

  # Swap Devices
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 8 * 1024;
    }
  ];

  # Setup nix
  nix.settings.experimental-features = ["flakes" "nix-command" "pipe-operators"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
