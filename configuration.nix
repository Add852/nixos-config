{ inputs, config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    # inputs.noctalia.homeModules.default
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable networking
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Asia/Manila"; # Set your time zone.
  i18n.defaultLocale = "en_PH.UTF-8"; # Select internationalisation properties.
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fil_PH";
    LC_IDENTIFICATION = "fil_PH";
    LC_MEASUREMENT = "fil_PH";
    LC_MONETARY = "fil_PH";
    LC_NAME = "fil_PH";
    LC_NUMERIC = "fil_PH";
    LC_PAPER = "fil_PH";
    LC_TELEPHONE = "fil_PH";
    LC_TIME = "fil_PH";
  };

  programs.hyprland = { # Enable hyperland Desktop Environment
    enable = true;
    withUWSM = true; # recommended for most users
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; # set the flake package
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # make sure to also set the portal package, so that they are in sync
  };

  # List packages installed in system profile. To search, run:
  nixpkgs.config.allowUnfree = true; # Allow unfree packages (cursor and other proprietary drivers)
  environment.systemPackages = with pkgs; [
    kdePackages.qtsvg #for dolphin icons
    kdePackages.kio # needed since 25.11 (dolphin dependencies)
    kdePackages.kio-fuse #to mount remote filesystems via FUSE (dolphin dependencies)
    kdePackages.kio-extras #extra protocols support (sftp, fish and more) (dolphin dependencies)
    kdePackages.dolphin # This is the actual dolphin package
    kdePackages.qtmultimedia #just to get SDDM theme working :/
  ];

  programs.firefox = { # firefox w/ pwa pluhh
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ]; # firefox pwa install
  };
  services.syncthing = { # syncthing: https://wiki.nixos.org/wiki/Syncthing
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
  };
  
  environment.variables.EDITOR = "code"; # set vscode as default text editor
  programs.vscode = {
    enable = true;
    # package = pkgs.vscode.fhs; # Use the FHS-compliant VS Code package
    extensions = with pkgs.vscode-extensions; [ # Add desired extensions here
      bbenoist.nix # Example: Nix language support
      dbaeumer.vscode-eslint # Example: ESLint extension
    ];
  };

  # DEVELOPER STUFFS
  services.openssh.enable = true;   # Enable the OpenSSH daemon.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";   #to use VSCODE on wayland
  networking.firewall = {   # Open ports in the firewall.
    enable = true;
    allowedTCPPorts = [ 8080 8384 ]; #web_localhost, syncthing port
    # allowedUDPPorts = [ ... ];
  };

  # HARDWARE and I/O STUFFS
  hardware.bluetooth.enable = true; #ForBluetooth
  services.upower.enable = true; #ForNoctalia Battery Status
  services.power-profiles-daemon.enable = true; #ForNoctalia Battery Profiles
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # media-session.enable = true; # use the example session manager (no others are packaged yet so this is enabled by default, no need to redefine it in your config for now)
  };
  # services.printing.enable = true;   # Enable CUPS to print documents.
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  #PERSONAL TWEAKS
  fonts.packages = with pkgs; [ #fonts
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];
  # disable built in laptop keyboard (see libinput device-list)
  services.udev.extraRules = ''
    KERNEL=="event0", ATTRS{name}=="AT Translated Set 2 keyboard", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  # Enable Flake, Automate Maintenance (GC and Updates)
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];   # Enable flakes w/ home manager
    auto-optimise-store = true;
  };
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  system.autoUpgrade = {
    enable = true;
    operation = "switch"; # If you don't want to apply updates immediately, only after rebooting, use `boot` option in this case
    flake = "/etc/nixos";
    flags = [ "--update-input" "nixpkgs" "--update-input" "--commit-lock-file" ];
    dates = "weekly";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
